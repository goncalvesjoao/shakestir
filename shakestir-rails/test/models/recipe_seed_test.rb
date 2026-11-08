require "test_helper"

class RecipeSeedTest < ActiveSupport::TestCase
  test "demo accounts have public signatures and private drafts with repeatable collections" do
    load Rails.root.join("db/seeds.rb")
    bartender = User.find_by!(email_address: "leo@shakestir.example")
    home = User.find_by!(email_address: "alex@shakestir.example")
    [ bartender, home, User.shakestir_account ].each { |user| assert user.image.attached? }
    image_ids = [ bartender, home, User.shakestir_account ].map { |user| user.image.blob_id }
    ProfileImagesSeeder.seed!
    assert_equal image_ids, [ bartender, home, User.shakestir_account ].map { |user| user.reload.image.blob_id }
    assert User.shakestir_account.authenticate("password")
    assert bartender.authenticate("password")
    assert home.authenticate("password")
    assert_equal 3, bartender.recipes.marketplace.count
    assert_equal 2, home.recipes.count
    assert home.recipes.all? { |recipe| recipe.visibility == "private" && recipe.publication_state == "draft" }
    assert_empty home.recipes.marketplace
    assert home.collections.all? { |collection| collection.visibility == "private" }
    assert_operator home.collections.where.not(name: "Favorites").minimum(:id), :>, 0
    assert home.collections.where.not(name: "Favorites").all? { |collection| collection.recipes.count >= 3 }
    assert bartender.collections.find_by!(name: "Halloween Special").recipes.where(user: users(:shakestir)).exists?
    assert_equal DemoCatalogSeeder.find_cocktail("Citrus Lantern"), DemoCatalogSeeder.find_cocktail("Frozen Lantern").parent_cocktail
    counts = [ User.count, Recipe.count, Collection.count, CollectionRecipe.count ]
    DemoAccountsSeeder.seed!
    assert_equal counts, [ User.count, Recipe.count, Collection.count, CollectionRecipe.count ]
  end

  test "demo seeds publish complete system recipes and repeat without duplication or overwriting curation" do
    load Rails.root.join("db/seeds.rb")
    imported = Recipe.where(source_reference: "ShakeStir original demo")
    assert_operator imported.marketplace.count, :>, 0
    assert imported.all? { |recipe| recipe.user == users(:shakestir) }
    recipe = imported.marketplace.first
    assert recipe.cocktail.present?
    assert imported.all? { |entry| entry.cocktail.image.attached? }
    content = DemoCatalogSeeder.load_json("cocktails.json").fetch("cocktails")
    content.each do |attributes|
      name = attributes.fetch("name")
      cocktail = Cocktail.find_by!(normalized_name: LookupName.normalize(name))
      assert cocktail.description.present?, name
      assert cocktail.history.present?, name
      assert_equal attributes.fetch("description"), cocktail.description
      assert_equal attributes.fetch("history"), cocktail.history
      assert_equal attributes.fetch("source_reference"), cocktail.source_reference
      assert_equal attributes.fetch("source_url"), cocktail.source_url
      assert cocktail.source_date_note.present?, name
    end
    assert recipe.cocktail.exclusive_photo?
    assert_not_equal recipe.image.blob.id, recipe.cocktail.image.blob.id
    photo_id = recipe.cocktail.image.blob.id
    assert recipe.recipe_steps.any?
    assert recipe.recipe_ingredients.any?
    assert recipe.source_url.start_with?("https://shakestir.example/recipes/")
    published_at = recipe.published_at
    counts = [ Cocktail.count, Recipe.count, RecipeIngredient.count, RecipeStep.count, ActiveStorage::Attachment.count ]
    DemoCatalogSeeder.seed!
    assert_equal counts, [ Cocktail.count, Recipe.count, RecipeIngredient.count, RecipeStep.count, ActiveStorage::Attachment.count ]
    assert_equal published_at, recipe.reload.published_at
    assert_equal photo_id, recipe.cocktail.image.blob.id
    recipe.update!(user: users(:shakestir), name: "Curated recipe")
    DemoCatalogSeeder.seed!
    assert_equal "Curated recipe", recipe.reload.name
  end

  test "seeds preserve existing imports and leave user owned recipes unchanged" do
    load Rails.root.join("db/seeds.rb")
    imported = Recipe.find_by!(source_url: "https://shakestir.example/recipes/citrus-lantern-01")
    owned = Recipe.find_by!(source_url: "https://shakestir.example/recipes/frozen-lantern-01")
    owned.update!(user: users(:one), name: "Personal variation")

    DemoCatalogSeeder.seed!
    assert_equal users(:shakestir), imported.reload.user
    assert_equal users(:shakestir).id, imported.user_id
    assert_equal "ShakeStir original demo", imported.source_reference
    assert_equal users(:one), owned.reload.user
    assert_equal users(:one), owned.user
    assert_equal "Personal variation", owned.name
  end

  test "canonical content backfills curated imports and preserves curated content and citations" do
    load Rails.root.join("db/seeds.rb")
    recipe = Recipe.find_by!(source_url: "https://shakestir.example/recipes/citrus-lantern-01")
    recipe.update!(user: users(:shakestir))
    cocktail = recipe.cocktail
    cocktail.update!(description: "Curated description", history: nil)
    cocktail.update!(source_reference: nil, source_url: nil, source_published_on: nil, source_date_note: nil)

    DemoCatalogSeeder.seed!
    expected = DemoCatalogSeeder.load_json("cocktails.json").fetch("cocktails").find { |entry| entry.fetch("name") == "Citrus Lantern" }
    assert_equal "Curated description", cocktail.reload.description
    assert_equal expected.fetch("history"), cocktail.history
    assert_equal expected.fetch("source_url"), cocktail.reload.source_url

    cocktail.update!(history: "Curated history")
    cocktail.update!(source_reference: "Curated source", source_url: nil, source_date_note: nil)
    DemoCatalogSeeder.seed_canonical_content!
    assert_equal "Curated history", cocktail.reload.history
    assert_equal "Curated source", cocktail.reload.source_reference
    assert_nil cocktail.source_url
    assert_nil cocktail.source_date_note
  end
end

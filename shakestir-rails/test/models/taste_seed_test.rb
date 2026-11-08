require "test_helper"

class TasteSeedTest < ActiveSupport::TestCase
  setup { load Rails.root.join("db/seeds.rb") }

  test "every exact imported and demo spec has a distinct documented expectation" do
    entries = TasteEstimatesSeeder.entries
    imported = Recipe.where(user: User.shakestir_account, source_reference: "ShakeStir original demo")
    assert_not_empty imported
    demo = Recipe.joins(:user).where(users: { email_address: TasteEstimatesSeeder::DEMO_EMAILS })
    assert_not_empty demo
    (imported.to_a + demo.to_a).each do |recipe|
      key = recipe.source_url.presence || "demo:#{recipe.user.email_address}:#{recipe.name}"
      unless entries.key?(key)
        TasteEstimatesSeeder::FIELDS.each { |field| assert_nil recipe[field] }
        next
      end
      entry = entries.fetch(key)
      assert_equal entry.fetch("spec_fingerprint"), TasteEstimatesSeeder.fingerprint(recipe), recipe.name
      TasteEstimatesSeeder::FIELDS.each { |field| assert_equal entry.fetch(field), recipe[field], "#{recipe.name}: #{field}" }
      assert entry.fetch("rationale").present?
    end
    assert_operator imported.find_by!(name: "Amber Evening").bitterness, :>, imported.find_by!(name: "Citrus Lantern").bitterness
    assert_operator imported.find_by!(name: "Soft Frozen Lantern").sweetness, :>, imported.find_by!(name: "Island Drift").sweetness
    assert_equal 0, imported.find_by!(name: "Amber Evening").sourness
  end

  test "reruns fill missing values without overwriting zeroes partial curation content or timestamps" do
    imported = Recipe.find_by!(source_url: "https://shakestir.example/recipes/amber-evening-01")
    demo = User.find_by!(email_address: "leo@shakestir.example").recipes.find_by!(name: "Midnight Velvet")
    [ imported, demo ].each { |recipe| recipe.update!(sweetness: 0, sourness: nil, bitterness: 4) }
    snapshot = [ imported, demo ].map { |r| [ r.name, r.steps, r.recipe_ingredients.pluck(:submitted_text), r.source_reference, r.source_url, r.published_at, r.updated_at ] }
    counts = [ Recipe.count, RecipeIngredient.count, RecipeStep.count ]
    DemoCatalogSeeder.seed!
    DemoAccountsSeeder.seed!
    [ imported, demo ].each do |recipe|
      assert_equal 0, recipe.reload.sweetness
      assert_equal 0, recipe.sourness
      assert_equal 4, recipe.bitterness
    end
    assert_equal snapshot, [ imported, demo ].map { |r| [ r.name, r.steps, r.recipe_ingredients.pluck(:submitted_text), r.source_reference, r.source_url, r.published_at, r.updated_at ] }
    assert_equal counts, [ Recipe.count, RecipeIngredient.count, RecipeStep.count ]
    before = [ imported, demo ].map(&:attributes)
    DemoCatalogSeeder.seed!
    DemoAccountsSeeder.seed!
    assert_equal before, [ imported, demo ].map { |r| r.reload.attributes }
  end

  test "changed preparations and requirement quantities do not receive stale estimates" do
    recipe = Recipe.find_by!(source_url: "https://shakestir.example/recipes/citrus-lantern-01")
    recipe.update!(sweetness: nil, sourness: nil, bitterness: nil)
    recipe.recipe_ingredients.first.update!(quantity: 99, measuring_unit: "ml")
    DemoCatalogSeeder.seed!
    assert_nil recipe.reload.sweetness
    assert_nil recipe.sourness
    demo = User.find_by!(email_address: "alex@shakestir.example").recipes.find_by!(name: "My Weekend Lantern")
    demo.update!(sweetness: nil, sourness: nil, bitterness: nil)
    demo.recipe_steps.first.update!(body: "An edited preparation.")
    DemoAccountsSeeder.seed!
    assert_nil demo.reload.sweetness
    assert_nil demo.bitterness
  end

  test "reassigned imported and demo recipes and unrelated source identities remain untouched" do
    imported = Recipe.find_by!(source_url: "https://shakestir.example/recipes/frozen-lantern-01")
    demo = User.find_by!(email_address: "leo@shakestir.example").recipes.find_by!(name: "Garden Notebook")
    [ imported, demo ].each { |recipe| recipe.update!(user: users(:one), sweetness: nil, sourness: nil, bitterness: nil) }
    unrelated = users(:one).recipes.create!(name: "Amber Evening", source_url: "https://example.com/my-negroni")
    before = [ imported, demo, unrelated ].map(&:attributes)
    DemoCatalogSeeder.seed!
    DemoAccountsSeeder.seed!
    assert_equal before, [ imported, demo, unrelated ].map { |r| r.reload.attributes }
  end
end

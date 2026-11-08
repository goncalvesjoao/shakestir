require "test_helper"
require_relative "../../db/seeds/techniques"

class TechniqueSeedTest < ActiveSupport::TestCase
  test "catalog is repeatable and preserves curated content" do
    technique = techniques(:shake)
    technique.update!(description: "Curated description")
    TechniquesSeeder.seed!
    assert Technique.all.all?(&:valid?)
    counts = [ Technique.count, RecipeTechnique.count ]
    TechniquesSeeder.seed!
    assert_equal counts, [ Technique.count, RecipeTechnique.count ]
    assert_equal "Curated description", technique.reload.description
    technique.update!(tip: nil)
    TechniquesSeeder.seed!
    assert_equal JSON.parse(TechniquesSeeder::ROOT.join("catalog.json").read).first.fetch("tip"), technique.reload.tip
  end

  test "reviewed links apply only to untouched system imports and preserve assignments" do
    load Rails.root.join("db/seeds.rb")
    spec = DemoCatalogSeeder.load_json("recipes.json").fetch("recipes").find { |entry| entry["id"] == "citrus-lantern-01" }
    recipe = Recipe.find_by!(source_url: spec.fetch("source_url"))
    recipe.recipe_techniques.destroy_all
    TechniquesSeeder.seed!
    assert_equal %w[shake strain], recipe.techniques.pluck(:slug)
    recipe.techniques = [ techniques(:stir) ]
    TechniquesSeeder.seed!
    assert_equal [ "stir" ], recipe.reload.techniques.pluck(:slug)
    recipe.recipe_techniques.destroy_all
    recipe.update!(user: users(:one))
    TechniquesSeeder.seed!
    assert_empty recipe.reload.techniques
    recipe.update!(user: users(:shakestir))
    recipe.recipe_steps.first.update!(body: "A curated preparation.")
    TechniquesSeeder.seed!
    assert_empty recipe.reload.techniques
  end
end

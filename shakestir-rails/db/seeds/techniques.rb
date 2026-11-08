require "json"

module TechniquesSeeder
  ROOT = Rails.root.parent.join("db", "seeds", "techniques")

  def self.seed!
    JSON.parse(ROOT.join("catalog.json").read).each do |entry|
      Technique.transaction do
        technique = Technique.find_or_initialize_by(slug: entry.fetch("slug"))
        %w[name description instructions tip].each do |field|
          technique.public_send("#{field}=", entry.fetch(field)) if technique[field].blank?
        end
        technique.save!
      end
    end
    seed_recipe_links!
  end

  def self.seed_recipe_links!
    return unless defined?(DemoCatalogSeeder)
    system_user = User.find_by(system_key: "shakestir")
    return unless system_user
    DemoCatalogSeeder.load_json("recipes.json").fetch("recipes").each do |spec|
      recipe = system_user.recipes.find_by(source_url: "#{DemoCatalogSeeder::URL_PREFIX}#{spec.fetch("id")}")
      next unless recipe && recipe.source_reference == DemoCatalogSeeder::SOURCE
      next unless recipe.recipe_steps.map(&:body) == spec.fetch("steps")
      next if recipe.recipe_techniques.exists?
      recipe.transaction do
        spec.fetch("techniques").each { |slug| recipe.recipe_techniques.create!(technique: Technique.find_by!(slug: slug)) }
      end
    end
  end
end

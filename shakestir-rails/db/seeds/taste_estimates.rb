require "json"
require "digest"

# Explicit, untested editorial expectations for the exact checked-in seed specs.
# Source recipe credit and prose are never changed by this loader.
module TasteEstimatesSeeder
  FIELDS = %w[sweetness sourness bitterness].freeze
  DEMO_EMAILS = JSON.parse(Rails.root.parent.join("db/seeds/demo_accounts.json").read)
    .fetch("accounts").map { |entry| entry.fetch("email_address") }.freeze

  def self.entries
    @entries ||= begin
      root = Rails.root.parent.join("db/seeds")
      system = JSON.parse(root.join("demo/recipes.json").read).fetch("recipes").map { |spec| [ spec.fetch("source_url"), spec ] }
      demo = JSON.parse(root.join("demo_accounts.json").read).fetch("recipes").map { |spec| [ "demo:#{spec.fetch("user")}:#{spec.fetch("name")}", spec ] }
      (system + demo).filter_map do |key, spec|
        next unless spec["taste"]
        [ key, spec.fetch("taste").merge(spec.slice("user", "source_url", "source_reference")).merge("spec_fingerprint" => spec.fetch("spec_fingerprint"), "rationale" => "Deliberate synthetic UI fixture values, not measured tasting results.") ]
      end.to_h
    end
  end

  def self.fingerprint(recipe)
    ingredients = recipe.recipe_ingredients.map { |line| [ LookupName.normalize(line.ingredient.name), line.submitted_text, line.quantity&.to_s("F"), line.measuring_unit, line.optional, line.role, line.preparation_note ] }
    Digest::SHA256.hexdigest(JSON.generate([ ingredients, recipe.recipe_steps.map(&:body) ]))
  end

  def self.fill_missing!(recipe, key:, owner:)
    entry = entries[key]
    return unless entry

    # lock! reloads its receiver, clearing ActiveStorage's pending after-commit
    # uploads. Keep the seed caller's instance intact inside outer transactions.
    stored_recipe = Recipe.find(recipe.id)
    stored_recipe.with_lock do
      return unless stored_recipe.user_id == owner.id
      if entry.fetch("source_url")
        return unless owner.email_address == entry.fetch("user") && stored_recipe.source_url == key && stored_recipe.source_reference == entry.fetch("source_reference")
      else
        return unless DEMO_EMAILS.include?(owner.email_address) && key == "demo:#{owner.email_address}:#{stored_recipe.name}" && stored_recipe.source_url.blank?
      end
      # A matching title or URL alone cannot justify estimating a curated spec.
      return unless fingerprint(stored_recipe) == entry.fetch("spec_fingerprint")

      missing = FIELDS.select { |field| stored_recipe[field].nil? }.index_with { |field| entry.fetch(field) }
      stored_recipe.update_columns(missing) if missing.any?
    end
  end
end

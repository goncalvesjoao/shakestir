require "json"
require "stringio"
require "digest"
require_relative "seeds/taste_estimates"
require_relative "seeds/utensils"
require_relative "seeds/techniques"

# Original offline demo content. Reruns preserve curation and unrelated records.
module DemoCatalogSeeder
  ROOT = Rails.root.parent.join("db", "seeds", "demo") unless const_defined?(:ROOT)

  def self.load_json(filename)
    JSON.parse(ROOT.join(filename).read)
  end

  def self.slugify(name)
    name.to_s.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/^-+|-+$/, "")
  end

  def self.find_cocktail(name)
    Cocktail.find_by(normalized_name: LookupName.normalize(name))
  end

  def self.attach_seed_image!(record, collection, name, filename: nil)
    return true if record.attachment_changes["image"]
    return true if record.image.attached? && record.image.blob.service.exist?(record.image.blob.key)
    path = ROOT.join("images", collection, filename || "#{slugify(name)}.png")
    raise "Missing original demo image: #{path}" unless path.file?
    bytes = path.binread
    if record.image.attached?
      blob = record.image.blob
      return false unless blob.checksum == Digest::MD5.base64digest(bytes) && blob.byte_size == bytes.bytesize
      blob.service.upload(blob.key, StringIO.new(bytes), checksum: blob.checksum)
    else
      record.image.attach(io: StringIO.new(bytes), filename: path.basename.to_s, content_type: "image/png")
    end
    true
  end

  def self.seed_ingredients!
    load_json("ingredients.json").fetch("ingredients").each do |entry|
      record = Ingredient.find_or_initialize_by(normalized_name: LookupName.normalize(entry.fetch("name")))
      record.name = entry.fetch("name") if record.new_record?
      record.description = entry.fetch("description") if record.description.blank?
      category = entry.fetch("type")
      record.category = category if record.new_record? || record.category == "other"
      record.alcohol_status = entry.fetch("alcohol") == "Yes" ? "alcoholic" : "non_alcoholic" if record.new_record? || record.alcohol_status == "unknown"
      record.alcohol_by_volume ||= entry.fetch("abv")
      attach_seed_image!(record, "ingredients", entry.fetch("name"))
      record.save!
    end
  end

  def self.seed_canonical_content!
    entries = load_json("cocktails.json").fetch("cocktails")
    entries.each do |entry|
      record = find_cocktail(entry.fetch("name")) || Cocktail.new(name: entry.fetch("name"))
      %w[description history].each { |field| record[field] = entry.fetch(field) if record[field].blank? }
      fields = %w[source_reference source_url source_published_on source_date_note]
      record.assign_attributes(entry.slice(*fields)) if fields.all? { |field| record[field].blank? }
      attach_seed_image!(record, "cocktails", entry.fetch("name"), filename: entry.fetch("image"))
      record.save!
    end
    entries.each do |entry|
      next unless entry["parent_cocktail"]
      record = find_cocktail(entry.fetch("name"))
      record.update!(parent_cocktail: find_cocktail(entry.fetch("parent_cocktail"))) if record.parent_cocktail_id.nil?
    end
  end

  def self.seed_recipe!(spec, owner:, source_url: spec.fetch("source_url"))
    recipe = source_url ? Recipe.find_by(source_url: source_url) : owner.recipes.find_by(id: Recipe.lookup(spec.fetch("name")).select(:id))
    key = source_url || "demo:#{owner.email_address}:#{spec.fetch("name")}"
    if recipe
      if recipe.user == owner && (!source_url || recipe.source_reference == spec.fetch("source_reference"))
        attach_seed_image!(recipe, "cocktails", spec.fetch("cocktail"), filename: spec.fetch("image"))
      end
      TasteEstimatesSeeder.fill_missing!(recipe, key: key, owner: owner)
      return recipe
    end
    Recipe.transaction do
      recipe = owner.recipes.new(name: spec.fetch("name"), cocktail: find_cocktail(spec.fetch("cocktail")),
        visibility: spec.fetch("visibility"), publication_state: "draft", source_url: source_url,
        source_reference: spec.fetch("source_reference"))
      attach_seed_image!(recipe, "cocktails", spec.fetch("cocktail"), filename: spec.fetch("image"))
      recipe.save!
      spec.fetch("ingredients").each_with_index do |line, position|
        ingredient = Ingredient.find_by!(normalized_name: LookupName.normalize(line.fetch("name")))
        recipe.recipe_ingredients.create!(line.except("name").merge("ingredient" => ingredient, "position" => position))
      end
      spec.fetch("utensils").each do |line|
        utensil = Utensil.find_by!(normalized_name: LookupName.normalize(line.fetch("name")))
        recipe.recipe_utensils.create!(line.except("name").merge("utensil" => utensil))
      end
      spec.fetch("steps").each_with_index do |body, position|
        step = recipe.recipe_steps.create!(body: body, position: position)
        spec.fetch("step_mentions").select { |mention| mention.fetch("step_position") == position }.each do |mention|
          field = mention.fetch("kind")
          type = { "ingredient" => Ingredient, "utensil" => Utensil }.fetch(field)
          identity = type.find_by!(normalized_name: LookupName.normalize(mention.fetch("name")))
          step.step_mentions.create!(mention.slice("start_offset", "end_offset", "quoted_text").merge(field => identity))
        end
      end
      spec.fetch("techniques").each do |slug|
        recipe.recipe_techniques.create!(technique: Technique.find_by!(slug: slug))
      end
      recipe.update!(publication_state: spec.fetch("publication_state"))
      TasteEstimatesSeeder.fill_missing!(recipe, key: key, owner: owner)
      recipe
    end
  end

  def self.seed!
    attributes = JSON.parse(Rails.root.parent.join("db/seeds/system_account.json").read)
    User.find_or_create_by!(system_key: attributes.fetch("system_key")) { |user| user.assign_attributes(attributes.except("system_key")) }
    seed_ingredients!
    UtensilsSeeder.seed!
    TechniquesSeeder.seed!
    seed_canonical_content!
    load_json("recipes.json").fetch("recipes").each do |spec|
      seed_recipe!(spec, owner: User.find_by!(email_address: spec.fetch("user")))
    end
  end
end

DemoCatalogSeeder.seed!
require_relative "seeds/demo_accounts"
DemoAccountsSeeder.seed! if Rails.env.development? || Rails.env.test?
require_relative "seeds/profile_images"
ProfileImagesSeeder.seed!

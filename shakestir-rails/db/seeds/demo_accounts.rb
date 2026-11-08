require "json"

module DemoAccountsSeeder
  def self.data
    JSON.parse(Rails.root.parent.join("db/seeds/demo_accounts.json").read)
  end

  def self.seed!
    entries = data
    User.transaction do
      accounts = entries.fetch("accounts").to_h do |entry|
        email = entry.fetch("email_address")
        [ email, account(email, entry.fetch("password"), entry.fetch("display_name"), entry.fetch("bio")) ]
      end
      recipes = entries.fetch("recipes").to_h do |entry|
        user = accounts.fetch(entry.fetch("user"))
        record = DemoCatalogSeeder.seed_recipe!(entry, owner: user)
        [ [ user.email_address, entry.fetch("name") ], record ]
      end
      entries.fetch("collections").each do |entry|
        members = entry.fetch("recipes").map do |reference|
          if reference.key?("cocktail")
            seed_recipe(reference.fetch("cocktail"))
          else
            recipes.fetch([ reference.fetch("user"), reference.fetch("name") ])
          end
        end
        collection(accounts.fetch(entry.fetch("user")), entry.fetch("name"), entry.fetch("visibility"), members)
      end
    end
  end

  def self.account(email, password, name, bio)
    User.find_or_create_by!(email_address: email) do |user|
      user.password = password
      user.display_name = name
      user.bio = bio
    end
  end

  def self.seed_recipe(name)
    DemoCatalogSeeder.find_cocktail(name)&.recipes&.marketplace&.find_by(user: User.shakestir_account)
  end

  def self.collection(user, name, visibility, recipes)
    collection = user.collections.find_or_create_by!(name: name) { |entry| entry.visibility = visibility }
    recipes.compact.each { |recipe| collection.collection_recipes.find_or_create_by!(recipe: recipe) }
  end
end

Rails.application.routes.draw do
  get "terms", to: "pages#terms", as: :terms
  get "privacy", to: "pages#privacy", as: :privacy
  get "cookies", to: "pages#cookie_policy", as: :cookies
  get "community-guidelines", to: "pages#community", as: :community_guidelines
  get "responsible-drinking", to: "pages#responsible_drinking", as: :responsible_drinking
  get "help", to: "pages#help", as: :help
  get "my/account", to: "account#show", as: :my_account
  delete "my/account", to: "account#destroy"
  get "my/recipes", to: "account#recipes", as: :my_recipes
  get "my/collections", to: "collections#index", as: :my_collections
  get "my/lists", to: redirect("/my/collections"), as: :my_lists
  resources :collection_recipes, only: :create
  resources :collections do
    resources :collection_recipes, only: %i[create destroy]
  end

  resources :user_profiles, only: %i[ show edit update ] do
    resource :image, only: :show, controller: "user_profile_images"
  end

  resource :registration, only: %i[ new create ]
  resource :session
  resources :passwords, param: :token
  resources :cocktails, only: %i[ index show ] do
    resource :image, only: :show, controller: "cocktail_images"
  end
  resources :techniques, only: %i[index show]
  resources :recipes do
    resource :star, only: %i[create destroy], controller: "recipe_stars"
    resource :image, only: :show, controller: "recipe_images"
  end
  resources :ingredients, only: %i[index show] do
    resource :image, only: :show, controller: "ingredient_images"
  end
  resources :utensils, only: %i[index show] do
    resource :image, only: :show, controller: "utensil_images"
  end
  scope ActiveStorage.routes_prefix do
    get "/disk/:encoded_key/*filename", to: "active_storage/disk#show", as: :rails_disk_service
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "recipes#index"
  match "*path", to: "errors#not_found", via: :all, constraints: ->(request) { request.format.json? }
end

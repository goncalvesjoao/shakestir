Rails.application.routes.draw do
  resources :recipes do
    resource :star, only: %i[create destroy], controller: "recipes/stars"
    resource :image, only: :show, controller: "recipes/images"
  end
  resources :cocktails, only: %i[ index show ] do
    resource :image, only: :show, controller: "cocktails/images"
  end
  resources :ingredients, only: %i[index show] do
    resource :image, only: :show, controller: "ingredients/images"
  end
  resources :utensils, only: %i[index show] do
    resource :image, only: :show, controller: "utensils/images"
  end
  resources :techniques, only: %i[index show]
  resources :collections, except: %i[ index ]

  scope module: "auth" do
    resource :registration, only: %i[ new create ]
    resource :session
    resources :passwords, param: :token
  end

  scope module: "pages" do
    get "terms-of-service"
    get "privacy-policy"
    get "cookies-policy"
    get "community-guidelines"
    get "responsible-drinking"
    get "help-and-contact"
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  scope ActiveStorage.routes_prefix do
    get "/disk/:encoded_key/*filename", to: "active_storage/disk#show", as: :rails_disk_service
  end

  scope module: "users", path: ":user_handle", as: :user do
    resource :account, only: %i[ show destroy ]
    resource :profile, only: %i[ show edit update ] do
      resource :image, only: :show, controller: "profiles/images"
    end
    resources :recipes, only: %i[ index ]
    resources :collections, only: %i[ index ]
  end

  # Defines the root path route ("/")
  root "recipes#index"
  match "*path", to: "errors#not_found", via: :all, constraints: ->(request) { request.format.json? }
end

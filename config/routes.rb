Rails.application.routes.draw do
  # get "home/index", to: "home#index"
  # Add the users resource explicitly first to give it higher priority
  resources :users, only: [ :new, :create ]

  # Custom route for sign-up with a friendly URL
  get "signup", to: "users#new", as: :signup

  # Keep session-related routes
  resource :session
  resources :passwords, param: :token

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
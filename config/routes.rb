Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"

  get "login" => "sessions#new", as: :login
  post "auth" => "sessions#create", as: :auth
  post "logout" => "sessions#destroy", as: :logout

  resources :bands
  resources :venues
  resources :search, only: [:index]
  resources :shows do
    member do
      post :publish
    end
  end
  resources :videos

  scope :admin do
    get "/" => "home#admin", as: :admin
    get "/features/set" => "features#set", as: :set_feature
    resources :features, only: [:edit, :update]
    resources :supporters, only: [:create, :update, :destroy]
  end
end

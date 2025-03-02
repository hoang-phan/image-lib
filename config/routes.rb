Rails.application.routes.draw do
  resources :images do
    member do
      post :rate
    end
    collection do
      get :multiple
      post :reset
      post :set_config
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check

  root to: "images#new"
end

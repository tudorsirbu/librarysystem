Rails.application.routes.draw do
  devise_for :admins
  resources :locations

  resources :loans

  resources :users do
    collection do
      post :find
    end
  end

  resources :categories

  resources :items

  root to: "dashboard#index"
end

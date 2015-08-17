Rails.application.routes.draw do
  resources :locations

  resources :loans

  resources :users

  resources :categories

  resources :items

  root to: "items#index"
end

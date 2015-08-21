Rails.application.routes.draw do
  devise_for :admins
  resources :locations

  resources :loans

  resources :users

  resources :categories

  resources :items

  root to: "dashboard#index"
end

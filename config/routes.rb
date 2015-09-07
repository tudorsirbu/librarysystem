Rails.application.routes.draw do
  devise_for :admins
  resources :locations


  resources :loans, except: [:new, :create,]

  resources :users do
    resources :loans, only: [:new, :create]
  end

  resources :categories

  resources :items

  root to: "dashboard#index"
end

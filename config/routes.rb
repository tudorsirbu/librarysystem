Rails.application.routes.draw do
  devise_for :admins
  resources :locations


  resources :loans, except: [:new, :create,]

  resources :users do
    resources :loans, only: [:new, :create, :return]
  end

  resources :categories

  resources :items

  root to: "dashboard#index"

  resources :dashboard, only: [:index, :menu] do
    collection do
      post :menu
      get :menu
    end
  end
end

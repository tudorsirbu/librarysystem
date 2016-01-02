Rails.application.routes.draw do
  devise_for :admins
  resources :locations


  resources :loans, except: [:new, :create,] do
    member do
      post :change_loan_period
    end
  end

  resources :users do
    resources :loans, only: [:new, :create]
    collection do
      post 'active'
      post 'inactive'
      post 'total'
    end
  end

  resources :categories

  resources :items do
    collection do
      get :return_scan
      post :return
      get :new_bulk
      post :create_bulk
      post :fImport
    end
    member do
      get :request_item
    end
  end

  resources :item_request, only: [:index]

  root to: "dashboard#index"

  resources :dashboard, only: [:index, :menu] do
    collection do
      post :menu
      get :logout
      get :menu
    end
  end
end

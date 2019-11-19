Rails.application.routes.draw do
  
  root to: 'toppages#index'
  
  resources :plans do
    resource :keeps, only: [:create, :destroy]
  end
  
  get 'signup', to: 'users#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  
  resources :users do
    member do
      get :keeps
    end
  end
end

Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  root 'static_pages#home'
  #get 'static_pages/home'

  #match '/help', to: 'static_pages#help', :via => [:get, :post]
  #match '/about', to: 'static_pages#about', :via => [:get, :post]
  #match '/contact', to: 'static_pages#contact', :via => [:get, :post]

  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete 'logout',   to: 'sessions#destroy'

  #the following block arranges the url will look like this:
  #get /users/1/following and /users/1/follower
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end

Rails.application.routes.draw do
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
  resources :users
  resources :account_activations, only: [:edit]
end

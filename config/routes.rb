Rails.application.routes.draw do
  root 'static_pages#home'
  get 'static_pages/home'

  match '/help', to: 'static_pages#help', :via => [:get, :post]
  match '/about', to: 'static_pages#about', :via => [:get, :post]
  match '/contact', to: 'static_pages#contact', :via => [:get, :post]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

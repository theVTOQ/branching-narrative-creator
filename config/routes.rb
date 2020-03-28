Rails.application.routes.draw do
  # Add your routes here
  root 'welcome#home'
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  #match '/auth/github/callback', to: 'sessions#create', via: [:get, :post]
  get '/welcome/home', to: 'welcome#home'
  get '/signup', to: 'users#new'
  delete '/signout' => 'sessions#destroy'

  resources :users, only: [:show, :create, :new]
end

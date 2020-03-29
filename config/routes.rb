Rails.application.routes.draw do
  # Add your routes here
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  #match '/auth/github/callback', to: 'sessions#create', via: [:get, :post]
  get '/welcome/home', to: 'welcome#home'
  get '/signup', to: 'users#new'
  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  delete '/signout' => 'sessions#destroy'

  resources :users, only: [:show, :create, :new] do
    resources :documents
  end

  resources :documents

  root 'welcome#home'
end

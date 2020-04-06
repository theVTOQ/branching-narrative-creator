Rails.application.routes.draw do
  # Add your routes here
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  #match '/auth/github/callback', to: 'sessions#create', via: [:get, :post]
  #get '/welcome/home', to: 'welcome#home'
  get '/signup', to: 'users#new'
  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  delete '/signout' => 'sessions#destroy'

  resources :users, only: [:show, :create, :new, :index] do
    resources :documents, only: [:index]
    resources :narratives, only: [:index, :show]
  end

  #resources :documents, only: [:index, :create, :update, :destroy]
  resources :documents, only: [:index, :create, :update, :destroy]
  
  resources :narratives do
    resources :documents, only: [:index, :show, :new, :edit, :new]
  end

  resources :branches, only: [:show, :create, :update, :edit, :destroy]

  root 'welcome#home'
end

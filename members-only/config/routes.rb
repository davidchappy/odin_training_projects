Rails.application.routes.draw do

  resources :posts, only: [:new, :create, :index]

  root 'posts#index'
  get '/about', to: 'static_pages#about'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

end

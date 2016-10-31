Rails.application.routes.draw do
  resources :users, only: [:new, :create, :show]
  get '/', to: 'users#new'
end

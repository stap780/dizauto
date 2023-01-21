require 'sidekiq/web'

Rails.application.routes.draw do

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  root to: 'home#index'
  get '/dashboard', to: 'home#dashboard', as: 'dashboard'


  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

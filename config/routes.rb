require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  resources :detals
  resources :exports
  resources :props
  resources :properties do
    resources :characteristics
  end
  resources :products do
    member do
      patch 'reorder_image'
      post 'update_image'
    end
    collection do
      get :characteristics
      post :delete_selected
      delete '/:id/images/:image_id', action: 'delete_image', as: 'delete_image'
    end
  end

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  root to: 'home#index'
  get '/dashboard', to: 'home#dashboard', as: 'dashboard'

  devise_for :users, controllers: {
    registrations:  'users/registrations',
    sessions:       'users/sessions',
    passwords:      'users/passwords',
  }

  resources :users



end

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  resources :permissions
  resources :email_setups
  resources :line_items
  resources :incases do
    collection do
      get :file_import
      post :import_setup
      post :convert_file_data
      post :create_from_import
      #put :update_from_file
    end
  end
  resources :places
  resources :warehouses
  resources :okrugs
  resources :companies
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
  root to: 'home#dashboard'
  get '/dashboard', to: 'home#dashboard', as: 'dashboard'

  devise_for :users, controllers: {
    registrations:  'users/registrations',
    sessions:       'users/sessions',
    passwords:      'users/passwords',
  }
  # devise patch create users inside service
    get  'users/admin_new' => 'users#admin_new'
    post 'users/admin_create' => 'users#admin_create'
  #########

  resources :users



end

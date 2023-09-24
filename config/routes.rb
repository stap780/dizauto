require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  resources :supplies
  resources :incase_item_statuses
  resources :incase_tips
  resources :incase_statuses
  resources :actions do
    collection do
      get :values
    end
  end
  resources :templs
  resources :triggers
  resources :delivery_types
  resources :payment_types
  resources :order_items
  resources :order_statuses
  resources :orders  do
    resources :comments, module: :orders
    member do
      get :print
    end
  end
  resources :client_companies do
    collection do
      get :new_turbo
    end
  end
  resources :clients do
    collection do
      post :create_turbo
      get :new_turbo
    end
  end
  resources :permissions
  resources :email_setups
  resources :incase_items
  resources :incases do
    resources :comments, module: :incases
    member do
      get 'act'
      get :print
    end
    collection do
      get :file_import
      post :import_setup
      post :convert_file_data
      post :create_from_import
      #put :update_from_file
      post :bulk_print
      get :pending_bulk 
      get :success_bulk
    end
  end
  resources :places
  resources :warehouses
  resources :okrugs
  resources :companies do
    resources :comments, module: :companies
  end
  resources :detals
  resources :exports
  resources :props do
    collection do
      get :characteristics
    end
  end
  resources :properties do
    resources :characteristics
  end
  resources :products do
    member do
      patch 'reorder_image'
      post 'update_image'
      get :print
    end
    collection do
      match 'search' => 'products#search', via: [:get, :post], as: :search
      get :characteristics
      post :delete_selected
      delete '/:id/images/:image_id', action: 'delete_image', as: 'delete_image'
      post :print_etiketki
      get :pending_etiketki 
      get :success_etiketki
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

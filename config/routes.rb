require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  resources :rent_case_statuses do
    member do
      patch :sort
    end 
  end
  resources :dashboards do
    collection do
      post :fullsearch
    end
  end
  resources :images do
    collection do
      post :upload
      post :delete
    end
  end
  resources :supply_statuses do
    member do
      patch :sort
    end 
  end
  resources :incase_imports do
    collection do
      post :bulk_print
      get :pending_bulk 
      get :success_bulk
      get '/:id/import_start', action: 'import_start', as: 'import_start'
      get '/:id/check_import', action: 'check_import', as: 'check_import'
    end
  end
  resources :supplies do
    collection do
      post :bulk_print
    end
  end
  resources :incase_item_statuses do
    member do
      patch :sort
    end 
  end
  resources :incase_tips do
    member do
      patch :sort
    end 
  end
  resources :incase_statuses do
    member do
      patch :sort
    end 
  end
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
      post :search
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
  resources :okrugs do
    member do
      patch :sort
    end   
  end
  resources :company_plan_dates do
    resources :comments, module: :company_plan_dates
  end
  resources :companies do
  end
  resources :detals
  resources :exports do
    member do
      get :download
      post :run
    end
  end
  resources :props do
    collection do
      get :characteristics
    end
  end
  resources :properties do
    resources :characteristics do
      collection do
        post :search
      end
    end
  end
  resources :products do
    member do
      get :print
      patch :sort_image
      post :copy
    end
    collection do
      post :search
      # match 'search' => 'products#search', via: [:get, :post], as: :search
      # get :characteristics
      post :delete_selected
      #delete '/:id/images/:image_id', action: 'delete_image', as: 'delete_image'
      post :print_etiketki
      get :pending_etiketki 
      get :success_etiketki
    end
  end

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: 'dashboards#index'
  # root to: 'home#dashboard'
  # get '/dashboard', to: 'home#dashboard', as: 'dashboard'

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

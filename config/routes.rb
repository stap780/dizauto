require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do

  resources :mitupais
  resources :avitos do
    member do
      get :check
    end
  end
  resources :shippings do
    resources :comments, module: :shippings
  end
  resources :telegram_bots do
    collection do
      get :run
      get :stop
    end
  end
  resources :insales do
    collection do
      post :order
      get :check
      get :add_order_webhook
    end
  end
  resources :stocks do
    collection do
      post :bulk_print
      post :download
    end
  end
  resources :stock_transfer_items
  resources :stock_transfers do
    resources :comments, module: :stock_transfers
    collection do
      get :slimselect_nested_item
      get :new_nested
      post :remove_nested
      post :download
      post :bulk_print
    end
  end
  resources :loss_items
  resources :losses do
    resources :comments, module: :losses
    collection do
      get :slimselect_nested_item
      get :new_nested
      post :remove_nested
      post :bulk_print
      post :download
    end
  end
  resources :enter_items
  resources :enters do
    resources :comments, module: :enters
    collection do
      get :slimselect_nested_item
      get :new_nested
      post :remove_nested
      post :download
    end
  end
  resources :inventory_statuses do
    member do
      patch :sort
    end
  end
  resources :stock_transfer_statuses do
    member do
      patch :sort
    end
  end
  resources :loss_statuses do
    member do
      patch :sort
    end
  end
  resources :enter_statuses do
    member do
      patch :sort
    end
  end
  resources :placements do
    resources :locations do
      resources :comments, module: :locations
    end
    collection do
      get :new_nested
      post :remove_nested
      post :download
    end
  end
  resources :return_items
  resources :return_statuses do
    member do
      patch :sort
    end
  end
  resources :returns do
    resources :comments, module: :returns
    collection do
      get :slimselect_nested_item
      get :new_nested
      post :remove_nested
      post :bulk_print
      post :download
    end
  end
  resources :invoice_items
  resources :invoice_statuses do
    member do
      patch :sort
    end
  end
  resources :invoices do
    resources :comments, module: :invoices
    collection do
      get :slimselect_nested_item
      get :new_nested
      post :remove_nested
      post :bulk_print
      post :download
      post :bulk_status
      post :bulk_status_update
    end
  end
  resources :rent_case_statuses do
    member do
      patch :sort
    end
  end
  resources :dashboards do
    collection do
      post :fullsearch
      post :product_created_at_count_chart
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
      get '/:id/start', action: 'start', as: 'start'
      get '/:id/check', action: 'check', as: 'check'
      post :download
    end
  end
  resources :supplies do
    resources :supply_items do
      collection do
        get :slimselect
      end
    end
    collection do
      post :bulk_print
      get :slimselect_nested_item
      get :new_nested
      post :remove_nested
      post :download
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
  resources :templs
  resources :triggers do
    resources :trigger_actions do
      collection do
        get :values
      end
    end
  end
  resources :delivery_types do
    member do
      patch :sort
    end
  end
  resources :payment_types do
    member do
      patch :sort
    end
  end
  resources :order_items
  resources :order_statuses do
    member do
      patch :sort
    end
  end
  resources :orders do
    resources :deliveries do
      collection do
      end
    end
    resources :comments, module: :orders
    collection do
      get :slimselect_nested_item
      get :new_nested
      post :remove_nested
      post :bulk_print
      post :download
      post :bulk_status
      post :bulk_status_update
      get :delivery
    end
    member do
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
      # post :create_turbo
      # get :new_turbo
      post :bulk_delete
      post :download
    end
  end
  
  resources :email_setups
  resources :incase_items
  resources :incases do
    resources :comments, module: :incases
    member do
      get :act
    end
    collection do
      post :new_supply
      post :create_from_import
      post :bulk_print
      get :slimselect_nested_item
      get :new_nested
      post :remove_nested
      post :download
      post :bulk_status
      post :bulk_status_update
    end
  end
  resources :warehouses do
    resources :places
    member do
      patch :sort
    end
  end
  resources :okrugs do
    member do
      patch :sort
    end
  end
  resources :company_plan_dates do
    resources :comments, module: :company_plan_dates
  end
  resources :companies do
    collection do
      post :search
      post :download
      post :bulk_delete
    end
  end
  resources :detals do
    resources :detal_props do
      collection do
        get :characteristics
      end
    end
  end
  resources :exports do
    member do
      get :download
      post :run
    end
  end
  resources :properties do
    resources :characteristics do
      collection do
        post :search
      end
    end
    collection do
      post :search
    end
  end
  resources :notifications, only: [:index]
  resources :products do
    resources :variants do
      resources :varbinds
      member do
        get :print_etiketka
      end
    end
    member do
      get :print
      patch :sort_image
      post :copy
      get :ai_description
      get :ai_description_get_task_id
      get :ai_description_get_content
      post :ai_description_copy
    end
    collection do
      post :search
      post :print_etiketki
      get :pending_etiketki
      get :success_etiketki
      post :price_edit
      post :price_update
      post :download
      post :bulk_delete
      post :bulk_print
    end
    resources :props do
      collection do
        get :characteristics
      end
    end
  end

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: 'dashboards#index'
  # root to: 'home#dashboard'
  # get '/dashboard', to: 'home#dashboard', as: 'dashboard'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }
  # devise patch create users inside service
  get 'users/admin_new' => 'users#admin_new'
  post 'users/admin_create' => 'users#admin_create'
  #########

  resources :users do
    resources :permissions
    member do
      post :read_notification
      post :delete_notification
    end
  end
end

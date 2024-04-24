require "sidekiq/web"
require "sidekiq-scheduler/web"

Rails.application.routes.draw do
  resources :return_items
  resources :return_statuses do
    member do
      patch :sort
    end
  end
  resources :returns do
    resources :comments, module: :orders
    collection do
      get :slimselect_nested_item
      get :new_nested
      post :remove_nested
      post :bulk_print
    end
  end
  resources :invoice_items
  resources :invoice_statuses do
    member do
      patch :sort
    end
  end
  resources :invoices do
    resources :comments, module: :orders
    collection do
      get :slimselect_nested_item
      get :new_nested
      post :remove_nested
      post :bulk_print
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
    end
  end
  resources :images do
    collection do
      post :upload
      post :delete
    end
  end
  resources :supply_items
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
      get "/:id/start", action: "start", as: "start"
      get "/:id/check", action: "check", as: "check"
    end
  end
  resources :supplies do
    collection do
      post :bulk_print
      get :slimselect_nested_item
      get :new_nested
      post :remove_nested
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
  # resources :actions do
  #   collection do
  #     get :values
  #   end
  # end
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
    resources :comments, module: :orders
    collection do
      get :slimselect_nested_item
      get :new_nested
      post :remove_nested
      post :bulk_print
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
      get :act
      get :new_supply
    end
    collection do
      post :create_from_import
      post :bulk_print
      get :slimselect_nested_item
      get :new_nested
      post :remove_nested
    end
  end
  resources :places
  resources :warehouses do
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
  end
  resources :notifications, only: [:index]
  resources :products do
    member do
      get :print
      patch :sort_image
      post :copy
    end
    collection do
      post :search
      post :delete_selected
      post :print_etiketki
      get :pending_etiketki
      get :success_etiketki
    end
    resources :props do
      collection do
        get :characteristics
      end
    end
  end

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  root to: "dashboards#index"
  # root to: 'home#dashboard'
  # get '/dashboard', to: 'home#dashboard', as: 'dashboard'

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    passwords: "users/passwords"
  }
  # devise patch create users inside service
  get "users/admin_new" => "users#admin_new"
  post "users/admin_create" => "users#admin_create"
  #########

  resources :users do
    member do
      post :read_notification
      post :delete_notification
    end
  end

end

require 'sidekiq/web'

Rails.application.routes.draw do

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

  # resources :users do
  #   collection do
  #     delete '/:id/images/:image_id', action: 'delete_image', as: 'delete_image'
  #   end
  # end



end

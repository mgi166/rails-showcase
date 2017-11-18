Rails.application.routes.draw do
  root to: 'top#index'

  resources :repositories, only: [:index]
  resources :users, only: [:index]

  resources :users, only: [:show], param: :login, constraint: { login: /[^\/]+/ } do
    resources :repositories, only: [:show], param: :name, constraint: { name: /[^\/]+/ }
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end

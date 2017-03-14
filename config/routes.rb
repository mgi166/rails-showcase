Rails.application.routes.draw do
  root to: 'top#index'

  resources :repositories, only: [:index]
  resources :repositories, only: [:show], param: :name
  resources :users, only: [:index, :show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

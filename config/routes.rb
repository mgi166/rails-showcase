Rails.application.routes.draw do
  root to: 'top#index'

  resources :repositories, only: [:index, :show]
  resources :users, only: [:index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

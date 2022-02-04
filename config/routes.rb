Rails.application.routes.draw do
  devise_for :users
  root to: "products#index"
  resources :products
  resources :payment_links, only: [:create]
  resources :webhooks, only: [:create]
end

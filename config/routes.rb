# frozen_string_literal: true

Rails.application.routes.draw do
  resources :publishers
  resources :categories
  resources :authors
  resources :books do
    resources :borrows 
  end
  devise_for :users
  root to: "home#index"
  get "/about", to: "home#about"
end

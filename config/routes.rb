# frozen_string_literal: true

Rails.application.routes.draw do
  resources :categories
  resources :authors
  resources :books
  devise_for :users
  root to: "home#index"
  get "/about", to: "home#about"
end

# frozen_string_literal: true

Rails.application.routes.draw do
  resources :notifications
    namespace :admin do
    resources :users
    resources :books
    resources :authors
    get '/dashboard', to: 'dashboard#home'
    resources :categories
    resources :publishers
    resources :borrows
    get "/showborrow", to:"borrows#showborrow"
    get "/showreturn", to:"borrows#showreturn"
  end
  resources :borrows
  resources :publishers
  resources :categories
  resources :authors
  resources :books do
    resources :borrows
    resources :reviews 
  end
  devise_for :users
  root to: "home#index"
  get "/about", to: "home#about"
  get "/showborrow", to:"borrows#showborrow"
  get "/showreturn", to:"borrows#showreturn"
end

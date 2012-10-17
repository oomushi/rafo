Rafo::Application.routes.draw do
  resources :images

  resources :icons

  resources :quotes

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"
  root :to => "quotes#index"
  resources :users
  resources :sessions
end

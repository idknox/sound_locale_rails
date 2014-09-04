Rails.application.routes.draw do
  root "events#map"
  get "/signin" => "sessions#new", as: :signin
  get "/signout" => "sessions#destroy", as: :signout
  post "/signin" => "sessions#create"
  get "/stubhub" => "stubhub#create", as: :stubhub
  delete "/events" => "events#destroy_all", as: :all_events
  get "/events/list" => "events#list"
  get "/venues/map" => "venues#map"
  get "/venues/list" => "venues#list"

  resources :venues
  resources :events
  resources :users

  resource :ticketflyevent, :only => :create
end
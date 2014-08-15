Rails.application.routes.draw do
  root "events#index"
  get "/signin" => "sessions#new", as: :signin
  get "/signout" => "sessions#destroy", as: :signout
  post "/signin" => "sessions#create"
  get "/ticketfly" => "ticketfly#create", as: :ticketfly
  delete "/events" => "events#destroy_all", as: :all_events
  get "/events/list" => "events#list", as: :events_list
  get "/venues/map" => "venues#map", as: :venues_map

  resources :venues
  resources :events

  resources :users
end
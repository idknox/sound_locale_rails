Rails.application.routes.draw do
  root "events#index"
  get "/signin" => "sessions#new", as: :signin
  get "/signout" => "sessions#destroy", as: :signout
  post "/signin" => "sessions#create"
  get "/events/map" => "events#map"
  get "/venues/map" => "venues#map"
  get "/events/more" => "events#more"
  get "/events/date/:date" => "events#by_date"

  resources :venues
  resources :events
  resources :users

end
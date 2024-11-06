# frozen_string_literal: true

Rails.application.routes.draw do
  # resources :geolocations
  get 'geolocations/', to: 'geolocations#show'
  post 'geolocations/', to: 'geolocations#create'
  delete 'geolocations/', to: 'geolocations#destroy'
end

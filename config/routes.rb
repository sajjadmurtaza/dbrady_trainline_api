# frozen_string_literal: true

# config/routes.rb

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :travel, only: [] do
        collection do
          get :find_trip_options
          get :find_trip_options_by_hardcoded_json
        end
      end
    end
  end
end

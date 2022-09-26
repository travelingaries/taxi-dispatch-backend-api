# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: [] do
    collection do
      post 'sign-in', action: :sign_in
      post 'sign-up', action: :sign_up
    end
  end

  resources 'taxi-requests', :as => :taxi_requests, :controller => :taxi_requests, only: %i(index create) do
    collection do
      post ':taxi_request_id/accept', action: :accept_request
    end
  end
end

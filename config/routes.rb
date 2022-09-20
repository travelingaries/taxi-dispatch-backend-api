Rails.application.routes.draw do
  resources :users, only: [] do
    collection do
      post 'sign-in', action: :sign_in
      post 'sign-up', action: :sign_up
    end
  end

  resources :taxi_requests, only: [:index] do
    collection do
    end
  end
end

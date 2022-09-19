Rails.application.routes.draw do
  resources :users, only: [:index] do
    collection do
    end
  end
end

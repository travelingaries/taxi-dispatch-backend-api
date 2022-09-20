Rails.application.routes.draw do
  resources :users, only: [] do
    collection do
      post :login
      post 'sign-up', action: :sign_up
    end
  end
end

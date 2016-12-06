Rails.application.routes.draw do
  mount_devise_token_auth_for 'Admin', at: '/admin/auth'
  resources :categories
  resources :resources do
    collection do
      get :search
    end

    resources :ratings, only: :create
  end
  resources :services do
    resources :ratings, only: :create
  end
end

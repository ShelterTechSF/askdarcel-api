Rails.application.routes.draw do
  mount_devise_token_auth_for 'Admin', at: '/admin/auth'
  resources :categories
  resources :resources do
    resources :notes, only: :create
    collection do
      get :search
    end

    post :create

    resources :ratings, only: :create
    resources :change_requests, only: :create
    resources :services, only: :create
  end
  resources :services do
    resources :ratings, only: :create
    resources :change_requests, only: :create
    resources :notes, only: :create
    post :approve
    post :reject
    collection do
      get :pending
    end
  end
  resources :notes do
    resources :change_requests, only: :create
  end
  resources :addresses do
    resources :change_requests, only: :create
  end
  resources :schedule_days do
    resources :change_requests, only: :create
  end
  resources :phones do
    resources :change_requests, only: :create
  end
  resources :change_requests do
    post :approve
    post :reject
  end
end

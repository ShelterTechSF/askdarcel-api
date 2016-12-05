Rails.application.routes.draw do
  resources :categories
  resources :resources do
    collection do
      get :search
    end

    resources :ratings, only: :create
    resources :changerequests, only: :create
  endgit
  resources :services do
    resources :ratings, only: :create
    resources :changerequests, only: :create
  end
  resources :changerequests do
    post :approve
    post :reject
  end
end

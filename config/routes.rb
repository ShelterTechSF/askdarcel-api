Rails.application.routes.draw do
  resources :categories
  resources :resources do
    resources :ratings
    collection do
      get :search
    end
  end
  resources :services do
    resources :ratings
  end
end

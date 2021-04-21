# frozen_string_literal: true

Rails.application.routes.draw do
  get 'textings/create'
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :categories do
    collection do
      get :counts
      get :featured
      get :subcategories
      get :hierarchy
    end
  end
  resources :eligibilities, only: %i[index show update] do
    collection do
      get :featured
    end
  end
  resources :resources do
    resources :notes, only: :create
    collection do
      get :count
    end

    post :create
    post :certify

    resources :change_requests, only: :create
    resources :services, only: :create
    resources :feedbacks, only: %i[create index]
  end
  resources :services do
    resources :change_requests, only: :create
    resources :notes, only: :create
    resources :feedbacks, only: %i[create index]
    post :approve
    post :reject
    post :certify
    collection do
      get :featured
      get :pending
      get :count
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
  resources :textings, only: %i[create destroy]
  resources :change_requests do
    post :create
    post :approve
    post :reject
    collection do
      get :pending_count
      get :activity_by_timeframe
    end
  end
  get 'reindex' => "algolia#reindex"
end

# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount_devise_token_auth_for 'Admin', at: '/admin/auth'
  resources :categories do
    collection do
      get :counts
    end
  end
  resources :eligibilities
  resources :resources do
    resources :notes, only: :create
    collection do
      get :search
    end

    post :create
    post :certify

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
    post :certify
    collection do
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
  resources :change_requests do
    post :approve
    post :reject
    collection do
      get :pending_count
      get :activity_by_timeframe
    end
  end
end

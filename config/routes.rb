# == Route Map
#

Rails.application.routes.draw do
  root to: 'sales_reports#index'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # OmniAuth
  devise_scope :user do
    get 'users/auth/google_oauth2/callback' => 'users/omniauth_callbacks#google_oauth2'
  end

  resources :users, only: [:index, :show]
  resources :plreports, only: [:index]
  resources :sales_reports, only: [:index, :show]
  resources :data_imports, only: [:index, :show]

  resources :data_imports, only: [] do
    collection do
      post :import
    end
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # 静的ページのルーティング
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms_of_service', to: 'static_pages#terms_of_service'
end

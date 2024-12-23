# == Route Map
#

Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :show]
  resources :plreports, only: [:index]
  root 'landing#index'

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
end

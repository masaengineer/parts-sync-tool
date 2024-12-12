# == Route Map
#

Rails.application.routes.draw do
  resources :users, only: [:index, :show, :edit, :update]
  resources :plreports, only: [:index]
  root 'landing#index'

  devise_for :users
  resources :sales_reports, only: [:index]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end

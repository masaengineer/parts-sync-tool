# == Route Map
#

Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :show]
  resources :plreports, only: [:index]
  root 'landing#index'

  resources :sales_reports, only: [:index, :show]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end

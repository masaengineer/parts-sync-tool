# == Route Map
#

Rails.application.routes.draw do
  root 'landing#index'

  devise_for :users

  resources :sales_reports, only: [:index]
  resources :orders, only: [:index]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end

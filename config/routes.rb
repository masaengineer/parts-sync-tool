# == Route Map
#

Rails.application.routes.draw do
  get "users/index"
  get "users/show"
  get "users/edit"
  get "users/update"
  get "plreports/index"
  resources :plreports, only: [:index]
  root 'landing#index'

  devise_for :users
  resources :sales_reports, only: [:index]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end

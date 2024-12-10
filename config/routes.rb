# == Route Map
#

Rails.application.routes.draw do
  get "sales_report/index"
  root 'pages#landing'
  resources :landing, only: [:index]
  resources :sales_report, only: [:index]

  # deviseのルートを追加
  devise_for :users

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end

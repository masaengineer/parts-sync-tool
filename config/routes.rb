# == Route Map
#

Rails.application.routes.draw do
  root 'pages#landing'
  resources :pages, only: [:landing]
  resources :sales_reports, only: [:index]

  # deviseのルートを追加
  devise_for :users

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end

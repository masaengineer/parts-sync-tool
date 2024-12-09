Rails.application.routes.draw do
  root 'pages#landing'
  get 'landing', to: 'pages#landing'
  get 'test', to: 'pages#test'

  # deviseのルートを追加
  devise_for :users

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end

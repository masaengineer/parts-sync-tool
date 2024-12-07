Rails.application.routes.draw do
  root 'pages#landing'
  get 'landing', to: 'pages#landing'
  # deviseのルートを追加
  devise_for :users


end

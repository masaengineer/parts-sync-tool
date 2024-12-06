Rails.application.routes.draw do
  root 'landing#index'
  get 'landing', to: 'landing#index'
  # deviseのルートを追加
  devise_for :users

  get 'dashboard', to: 'dashboard#index', as: :dashboard
  get 'components', to: 'components#index', as: :components
end

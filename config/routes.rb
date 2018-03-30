Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "user/registrations"}

  root to: 'welcome#index'

  get 'my_portfolio', to: 'users#my_portfolio', as: 'my_portfolio'
  get 'search_stocks', to: 'stocks#search', as: 'search_stock'

  resources :user_stocks, only: [:create, :destroy]
end

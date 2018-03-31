Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "user/registrations"}

  resources :friendships
  resources :user_stocks, only: [:create, :destroy]

  root to: 'welcome#index'

  # Users controller
  resources :users, only: [:show]
  get '/my_friends/', to: "users#my_friends", as: 'my_friends'
  get '/my_portfolio/', to: 'users#my_portfolio', as: 'my_portfolio'
	get '/search_friends/', to: 'users#search', as: 'search_friends'
  post '/add_friend/', to: 'users#add_friend_action', as: 'add_friend'

	# Stocks controller  
  get '/search_stocks/', to: 'stocks#search', as: 'search_stock'
  
end
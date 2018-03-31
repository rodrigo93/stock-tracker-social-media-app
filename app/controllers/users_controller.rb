class UsersController < ApplicationController

	def my_friends
		
	end

	def my_portfolio
		@user = current_user
		@user_stocks = current_user.stocks		
	end

end
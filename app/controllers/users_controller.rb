class UsersController < ApplicationController

	def add_friend_action
		@friend = User.find(params[:friend])
		current_user.friendships.build(friend_id: @friend.id)

		if current_user.save
			flash[:success] = "Friend added!"
		else
			flash[:danger] = "Could not add friend."
		end

		redirect_to my_friends_path
	end

	def my_friends
		@friendships = current_user.friends
	end

	def my_portfolio
		@user = current_user
		@user_stocks = current_user.stocks		
	end

	def search
		if params[:search_param].present?
			@users = User.search(params[:search_param])
			@users = current_user.except_current_user(@users)
			flash.now[:danger] = "No user found" unless @users
		else
			flash.now[:danger] = "You have entered an empty search string"
		end
		respond_to do |format|
			format.js { render partial: 'friends/result' }
		end
	end

	def show
		@user = User.find(params[:id])
		@user_stocks = @user.stocks
	end

end
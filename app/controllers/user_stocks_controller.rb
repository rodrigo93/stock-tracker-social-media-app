class UserStocksController < ApplicationController
	
	def create
		ticker = params[:stock_ticker]
		stock = Stock.find_by_ticker(ticker)				
		unless stock.present?
			stock = Stock.new_from_lookup(ticker)
			stock.save
		end
		@user_stock = UserStock.create(user: current_user, stock: stock)
		flash[:success] = "Stock #{@user_stock.stock.name} was successfully added to your portfolio! :)"
		redirect_to my_portfolio_path
	end

	def destroy
		stock = Stock.find(params[:id])
		@user_stock = UserStock.where(user_id: current_user.id, stock_id: stock.id).first
		@user_stock.destroy
		flash[:notice] = "Stock was successfully removed from portfolio"
		redirect_to my_portfolio_path
	end

end

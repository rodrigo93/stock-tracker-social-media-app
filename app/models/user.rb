class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :friendships
  has_many :friends, through: :friendships
  has_many :user_stocks
  has_many :stocks, through: :user_stocks

  def can_add_stock?(ticker_symbol)
  	under_stock_limit? and !stock_already_added?(ticker_symbol)
  end

  def full_name
    return "#{self.first_name} #{self.last_name}".strip if (first_name or last_name)
    "Anonymous"
  end

  def stock_already_added?(ticker_symbol)
    stock = Stock.find_by_ticker(ticker_symbol).first
    return false unless stock.present?
    user_stocks.where(stock_id: stock.id).exists?
  end

  def under_stock_limit?
    user_stocks.count < 10
  end
end

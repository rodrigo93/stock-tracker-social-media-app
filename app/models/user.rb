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

  def except_current_user(users)
    users.reject{ |user| user.id == self.id}
  end

  def full_name
    return "#{self.first_name} #{self.last_name}".strip if (first_name or last_name)
    "Anonymous"
  end

  def not_friends_with?(friend_id)
    self.friendships.where(friend_id: friend_id).count < 1
  end

  def self.first_name_matches(param)
    matches('first_name', param)
  end

  def self.email_matches(param)
    matches('email', param)
  end

  def self.last_name_matches(param)
    matches('last_name', param)
  end

  def self.matches(field_name, param)
    User.where("#{field_name} like?", "%#{param}%")
  end

  def self.search(param)
    param.strip!
    param.downcase!
    result = (first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq
    return nil unless result.present?
    result
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

class User < ApplicationRecord
  delegate :can?, :cannot?, to: :ability
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :borrows, dependent: :destroy
  has_many :books, through: :borrows
  has_many :reviews, dependent: :destroy
  has_many :notifications, dependent: :destroy

  scope :year, lambda{|year|
    where(" EXTRACT(YEAR FROM users.created_at) = ? ", year ) if year.present?  
  }
  scope :month, lambda{|month|
      where(" EXTRACT(MONTH FROM created_at) = ? ", month ) if month.present?  
  } 
  scope :group_by_month,   -> { group("EXTRACT(MONTH FROM created_at) ") }
  scope :group_by_year,   -> { group("EXTRACT(YEAR FROM created_at) ") }
  
  def ability
    @ability ||= Ability.new(self)
  end

  def self.search(search)
    if search
        where("email  LIKE ? OR id = #{search}", "%#{search}%")
    else
        all
    end
  end

  def self.count_user_by_month(y)
    @hash_quantity_user = User.where(role: "user").year(y).group_by_month.count

  end

  # @return a has with: key is year, value is quantity user
  def self.count_by_year(year_start, year_end)
    @quantity_borrow = User.where(" EXTRACT(YEAR FROM created_at) between ? and ? ", year_start,year_end ).where(role:"user").group_by_year.count
end
end

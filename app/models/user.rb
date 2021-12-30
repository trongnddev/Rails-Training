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

  def self.count_user_by_month(y = Time.now.year)
    new_users = Array.new(12,0)
    @hash_quantity_user = User.where(role: "user").year(y).group_by_month.count
    @hash_quantity_user.each {|k,v| new_users[k-1] = v}
    new_users
  end

  
end

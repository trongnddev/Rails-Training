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
end

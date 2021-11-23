class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :borrows, dependent: :destroy
  has_many :books, through: :borrows

  def self.search(search)
    if search
        where("email  LIKE ? OR id = #{search}", "%#{search}%")
    else
        all
    end
end
end

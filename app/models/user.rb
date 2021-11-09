class User < ApplicationRecord
  delegate :can?, :cannot?, to: :ability
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def ability
    @ability ||= Ability.new(self)
  end
end

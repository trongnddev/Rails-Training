class Category < ApplicationRecord
  has_many :books, dependent: :destroy
  validates :name, presence: true, uniqueness: true, format: {with: /\A[[:alpha:][:blank:]]+\z/ }
  before_create {|category| category.name = category.name.capitalize}
end

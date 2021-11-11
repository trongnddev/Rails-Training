class Book < ApplicationRecord
  has_one_attached :image
  has_many :author_books, dependent: :destroy
  has_many :authors, through: :author_books
  belongs_to :category, optional: true
  accepts_nested_attributes_for :author_books
end

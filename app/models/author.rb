class Author < ApplicationRecord
  has_many :author_books, dependent: :destroy
  has_many :books, through: :author_books
  accepts_nested_attributes_for :author_books
  validates_format_of :author_name, with: /\A[[:alpha:][:blank:]]+\z/
  before_create { |author| author.author_name= author.author_name.capitalize}
end

class Book < ApplicationRecord
  has_one_attached :image
  has_many :author_books, dependent: :destroy
  has_many :authors, through: :author_books
  has_many :borrows, dependent: :destroy
  has_many :users, through: :borrows
  belongs_to :category, optional: true
  belongs_to :publisher, optional: true
  accepts_nested_attributes_for :author_books
  validates_format_of :name, with: /\A(?![0-9]+$)[a-zA-Z0-9 ]{2,}\z/
  before_create { |book| book.name = book.name.capitalize}

  
  def self.search(search)
    if search
      Book.includes(:authors).where("books.name LIKE '%#{search.capitalize}%' OR authors.author_name LIKE '%#{search.capitalize}%'").references(:author_books)
    else
      all
    end  
  end
end

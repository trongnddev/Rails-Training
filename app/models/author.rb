class Author < ApplicationRecord
  has_many :author_books, dependent: :destroy
  has_many :books, through: :author_books
  accepts_nested_attributes_for :author_books

  
  def self.search(search)
    if search
      where("authors.author_name LIKE '%#{search.capitalize}%'") 
    else
      all
    end  
  end


end

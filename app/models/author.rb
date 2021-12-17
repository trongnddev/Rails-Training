class Author < ApplicationRecord
  has_many :author_books, dependent: :destroy
  has_many :books, through: :author_books
  has_one_attached :image
  accepts_nested_attributes_for :author_books
  validates_format_of :author_name, with: /\A[[:alpha:][:blank:]]+\z/
  before_create {|author| author.author_name = author.author_name.titleize} 

  
  def self.search(search)
    if search
      where("authors.author_name LIKE '%#{search.titleize}%'") 
    else
      all
    end  
  end

  def self.filter(param_filter)
    if param_filter
      where("authors.author_name = ?",param_filter)
    else
      all
    end
  end


end

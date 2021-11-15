class AuthorBook < ApplicationRecord
  belongs_to :author, optional: true
  belongs_to :book, optional: true 
  accepts_nested_attributes_for :book, allow_destroy: true, reject_if: proc { |att| att['name'].blank? }
  accepts_nested_attributes_for :author



  def book_attributes=(book_attributes)
    book_attributes.values.each do |book_attribute|
      self.book = Book.find_or_create_by(name: book_attribute)
    end
  end

  def author_attributes=(author_attributes)
    author_attributes.values.each do |author_attribute|
      self.author = Author.find_or_create_by(author_name: author_attribute)
    end
  end

end

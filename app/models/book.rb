class Book < ApplicationRecord
  has_one_attached :image
  has_many :author_books, dependent: :destroy
  has_many :authors, through: :author_books
  has_many :borrows, dependent: :destroy
  has_many :users, through: :borrows
  belongs_to :category, optional: true
  belongs_to :publisher, optional: true
  has_many :reviews, dependent: :destroy
  accepts_nested_attributes_for :author_books
  validates_format_of :name, with: /\A(?!^\d+$)^.+$\z/
  validates :borrow_fee, numericality: { greater_than: 0 }, allow_nil: true
  before_create {|book| book.name = book.name.titleize }

  def self.hotbooks 
    all.order("total_borrow DESC")[0]
  end

  def self.newest
    Book.all.order("id DESC").limit(3) 
  end

  def self.sort(param)
    if param == "Select"
      all 
    elsif param == "Newest books"
      all.order("published_date desc")
    elsif param == "Oldest books"
      all.order("published_date asc")
    elsif param == "Fee low to high"
      all.order("borrow_fee asc")
    elsif param == "Fee high to low"
      all.order("borrow_fee desc")
    elsif param == "Most borrow"
      all.order("total_borrow desc")
    else
      all
    end 
  end

  def self.filter(query)
    book = Book.includes(:authors).references(:author_books)
    author_id = query[0] unless query[0] == ""
    category_id = query[1] unless query[1] == ""
    publisher_id = query[2] unless query[2] == ""
    if author_id && category_id && publisher_id
      book.where("authors.id = ? AND books.category_id = ? AND books.publisher_id = ?",author_id,category_id,publisher_id)
    elsif author_id
      if category_id 
        book.where("authors.id = ? AND books.category_id = ?",author_id,category_id)
      elsif publisher_id
        book.where("authors.id = ? AND books.publisher_id = ?",author_id,publisher_id)
      else
        book.where("authors.id = ?",author_id)
      end
    elsif category_id
      if author_id
        book.where("authors.id = ? AND books.category_id = ?",author_id,category_id)
      elsif publisher_id
        book.where("books.category_id = ? AND books.publisher_id = ?",category_id,publisher_id)
      else
        book.where("books.category_id = ?",category_id)
      end
    elsif publisher_id
      if author_id
        book.where("authors.id = ? AND books.publisher_id = ?",author_id,publisher_id)
      elsif category_id
        book.where("books.category_id = ? AND books.publisher_id = ?",category_id,publisher_id)
      else
        book.where("books.publisher_id = ?",publisher_id)
      end
    else
      all
    end 
  end
  
  def self.search(query)
    book_author = Book.includes(:authors).references(:author_books)
    book_pub = book_author.includes(:publisher)
    book = book_pub.includes(:category)
    if query
      book.where("books.name LIKE '%#{query.titleize}%' OR
        authors.author_name LIKE '%#{query.titleize}%' OR
        categories.name LIKE '%#{query.capitalize}%' OR
        publishers.publisher_name LIKE '%#{query.upcase}%' OR
        books.description LIKE '%#{query}%'
        ")
    else
      all
    end
  end

  def self.exist_quantity
    totals = 0
    Book.all.each do |book|
      totals += book.quantity_in_stock
    end
    totals
  end

end

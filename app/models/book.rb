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

  def self.hotbooks 
    hot_array = Borrow.group(:book_id).count.sort.to_a
    Book.find(hot_array[0][0]) if hot_array.present?
  end

  def self.newest
    Book.all.order("id DESC").limit(3) 
  end

  def self.sort_search_filter(param)
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
    else
      all
    end 
  end

  
end

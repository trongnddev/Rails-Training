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

<<<<<<< HEAD
  
  def self.hotbooks 
    hot_array = Borrow.group(:book_id).count.sort.to_a
    Book.find(hot_array[0][0])
  end

  def self.newest
    Book.all.order("id DESC").limit(3) 
  end

=======
  def self.hotbooks 
    hot_array = Borrow.group(:book_id).count.sort.to_a
    Book.find(hot_array[0][0])
  end

  def self.newest
    Book.all.order("id DESC").limit(3) 
  end


  
>>>>>>> 1f172fdd58cb2583dbca8ccdfa7f757fab6f6e47
end

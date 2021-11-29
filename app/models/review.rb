class Review < ApplicationRecord
    after_create :update_rating
    after_destroy :update_rating
    belongs_to :book
    belongs_to :user
    validates :comment, :star, presence: true


    def username
      self.user.email.split("@")[0].capitalize
    end


    def update_rating
      book = Book.find(book_id)
      review_book = Review.where(book_id: book_id)
      book.update(rating: (review_book.sum(:star).to_i)/ review_book.count.to_i) 
    end
end

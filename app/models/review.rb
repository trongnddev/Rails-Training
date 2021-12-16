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
      review_book = Review.where(book_id: book_id)
      unless review_book.empty?
        book.update(rating: (review_book.sum(:star).to_i)/ review_book.count.to_i)
      else
        book.update(rating: 0)
      end
    end
end

class Borrow < ApplicationRecord
    belongs_to :user
    belongs_to :book
    after_update :update_stock
    before_destroy :destroy_update
    def self.search(search)
        if search
            where(status: "#{search}")
        else
            all
        end
    end


    def update_stock
        book = Book.find(book_id)
        if status.include? "accept"
            book.update_column(:quantity_in_stock, book.quantity_in_stock - 1)
            update_column(:borrowed_date, Time.now)
        elsif status.include? "returned"
            update_column(:returned_date, Time.now)
            days_penalty = (returned_date.day- borrowed_date.day).to_i - appointment_returned_date
            if days_penalty > 0
                penalty_fee = days_penalty * book.borrow_fee * 0.5
            else
                penalty_fee = 0
            end
            update_column(:penalty_fee, penalty_fee)
            book.update_column(:quantity_in_stock, book.quantity_in_stock + 1)
        end
    end

    def destroy_update
        book = Book.find(book_id)
        if status.include?"accept"
            book.update_column(:quantity_in_stock, book.quantity_in_stock + 1)
        end
    end
end

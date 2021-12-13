class Borrow < ApplicationRecord
    belongs_to :user
    belongs_to :book
    after_update :update_stock, :create_notification
    before_destroy :destroy_update
    
    
    def self.search(search)
        if search
            where(status: "#{search}")
        else
            all
        end
    end
    def send_notification
        NotificationBroadcastJob.perform_now(self)
      end

    def create_notification
        @notification = Notification.new()
        @notification.user_id = user_id
        
        
        if status.include? "accept"
            @notification.message = "You was be alowed to borrow a book #{book.name}"
        elsif status.include? "cancel"
            @notification.message = "Request to borrow book #{book.name} be denied"
        elsif status.include? "returned"
            @notification.message = "You was returned a book #{book.name}"
        end

        if @notification.message?
            @notification.save
            @notification.update_column( :created_at, Time.now.in_time_zone(+7))
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

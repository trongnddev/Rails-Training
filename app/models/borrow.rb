class Borrow < ApplicationRecord
    belongs_to :user
    belongs_to :book
    after_update :update_stock, :create_notification, :after_returned_notification
    before_destroy :destroy_update
    after_create :notification_staff
    
    
    def self.search(search)
        if search
            where(status: "#{search}")
        else
            all
        end
    end

    def create_notification     
        notification = Notification.find_by(:message => "for staff", :user_id => user_id)
        unless notification.nil?
            if status.include? "accept"
                notification.update_column(:message, "You was be allowed to borrow a book #{book.name}")
            elsif status.include? "cancel"
                notification.update_column(:message, "Request to borrow book #{book.name} be denied")
            end
            notification.update_column( :created_at, Time.now.in_time_zone(+7))
        end
    end

    def after_returned_notification
        if status.include? "returned" 
            notification = Notification.find_by(:user_id => user_id)
            notification.update_column(:message, "You was returned a book #{book.name}") unless notification.nil?
            notification.update_column( :created_at, Time.now.in_time_zone(+7))
        end
    end

    def notification_staff
        notification = Notification.new(:message => "for staff", :user_id => user_id)
        notification.save 
    end
        


    def update_stock
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
        if status.include?"accept"
            book.update_column(:quantity_in_stock, book.quantity_in_stock + 1)
        end
    end
end

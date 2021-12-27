require 'csv'
class Borrow < ApplicationRecord
    belongs_to :user
    belongs_to :book
    after_update :update_stock, :create_notification, :after_returned_notification, :book_total_borrow
    before_destroy :destroy_update
    after_create :notification_staff
    
    scope :year, lambda{|year|
        where(" EXTRACT(YEAR FROM borrowed_date) = ? ", year ) if year.present?  
    }
    scope :month, lambda{|month|
        where(" EXTRACT(MONTH FROM borrowed_date) = ? ", month ) if month.present?  
    }
    scope :group_by_month,   -> { group("EXTRACT(MONTH FROM borrowed_date) ") }

    def self.search(search)
        if search
            where(status: "#{search}")
        else
            all
        end
    end

    def check_user
        
    end

    def create_notification     
        notification = Notification.find_by(:message => "for staff", :user_id => user_id)
        unless notification.nil?
            if status.include? "accept"
                notification.update_column(:message, "You was be allowed to borrow a book #{book.name}")
                notification.update_column(:borrow_id, id)
            elsif status.include? "cancel"
                notification.update_column(:message, "Request to borrow book #{book.name} be denied")
                notification.update_column(:borrow_id, id)
            end
            notification.update_column( :created_at, Time.now.in_time_zone(+7))
        end
    end

    def after_returned_notification
        if status.include? "returned" 
            notification = Notification.new(:message => "You was returned a book #{book.name}",
                :user_id => user_id,
                :created_at => Time.now.in_time_zone(+7),
                :borrow_id => id,
                :book_id => book_id)
            notification.save
        end
    end

    def notification_staff
        notification = Notification.new(:message => "for staff", :user_id => user_id)
        notification.save 
    end
      
    def book_total_borrow
        if status.include? "returned"
            total = Borrow.where(:book_id => book_id).count 
            book.update_column(:total_borrow,total)
        end
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
    def self.returned_to_csv
        CSV.generate do |csv|
            csv << ['ID','Borrowed date','Returned date','Book','User','Borrow fee','Penalty fee']
            Borrow.where(:status => "returned").each do |borrow_returned|
                csv << [borrow_returned.id,borrow_returned.borrowed_date,borrow_returned.returned_date,borrow_returned.book.name,borrow_returned.user.email,borrow_returned.book.borrow_fee,borrow_returned.penalty_fee]
            end
        end
    end

    def self.book_order_csv
        CSV.generate do |csv|
            csv << ['ID','Book','User','Borrow date','Appointment returned date','Borrow fee']
            Borrow.where(:status => "waiting accept").each do |order|
                csv << [order.id,order.book.name,order.user.email,order.borrowed_date,order.borrowed_date+14,order.book.borrow_fee]
            end
        end
    end

    def self.count_by_year(y)
        @quantity_borrow = Borrow.where({status: "returned"}).year(y).count
    end
    # @return a hash has key is month, value is quantity 
    def self.count_by_group_month(y)
        @quantity_borrow = Borrow.where.not(status: "waiting accept").year(y).group_by_month.count
    end

 

    # def self.count_by_month(m,y)
    #     @quantity_borrow = Borrow.where(status: "returned").year(y).month(m).count
    # end



end

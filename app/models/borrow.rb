require 'csv'
class Borrow < ApplicationRecord
    belongs_to :user
    belongs_to :book
    after_update :update_stock, :create_notification, :after_returned_notification, :book_total_borrow
    before_destroy :destroy_update
    after_create :notification_staff
    
    scope :year, lambda{|year|
        where(" EXTRACT(YEAR FROM borrows.borrowed_date) = ? ", year ) if year.present?  
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
            notification.update_column( :created_at, Time.now)
        end
    end

    def after_returned_notification
        if status.include? "returned" 
            notification = Notification.new(:message => "You was returned a book #{book.name}",
                :user_id => user_id,
                :created_at => Time.now,
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
    
    # @return a hash has key is month, value is quantity borrow
    def self.count_by_group_month(y = Time.now.year )
        @values_borrows = Array.new(12,0)
        @quantity_borrow = Borrow.where.not(status: "waiting accept").year(y).group_by_month.count
        @quantity_borrow.each do |k,v|
            @values_borrows[k-1] = v
        end
        @values_borrows
    end

    def self.get_top_three_user(year = Time.now.year, month = (Time.now.month - 1))
        @users = Borrow.joins(:user).year(year).month(month).group('users.id').order("count_all DESC").limit(3).count
        # hash_result 
    end
     

    def self.get_top_three_book(year = Time.now.year, month = (Time.now.month - 1))
        @books = Borrow.joins(:book).year(year).month(month).group('books.id')
            .order("count_all DESC").limit(3).count
    end
    
    def self.get_top_three_author(year = Time.now.year, month = (Time.now.month - 1))
        @books = Borrow.joins(book: {author_books: :author}).year(year).month(month)
            .group("authors.id").order("count_all DESC").limit(3).count
    end

    # @return a hash with key is month and value is turnover
    def self.count_turnover_by_month(year = (Time.now.year - 1))
        @sum_fees =  Borrow.joins(:book).year(year).where(status: "returned").group_by_month.sum("borrow_fee")
        @sum_penalty_fees =  Borrow.year(year).where(status: "returned").group_by_month.sum("penalty_fee")
        @sum_fees.merge(@sum_penalty_fees) {|k,value_fee,value_penalty| value_fee + value_penalty}
        @results = Array.new(12,0)
        @sum_fees.each {|k,v| @results[k-1] = v}
        @results
    end 


    def self.proceeds_in_day
        total_proceeds = 0
        Borrow.where(updated_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: "returned").each do |borrow|
            total_proceeds += Book.find(borrow.book_id).borrow_fee + borrow.penalty_fee
        end
        total_proceeds
    end
end

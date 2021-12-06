class Admin::DashboardController < AdminController
    def home
        @total_users = User.all.count
        @new_users = User.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count
        @total_authors = Author.all.count
        @new_authors = Author.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count
        @total_books = Book.all.count
        @new_books = Book.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count
        @books_list = Book.all.order("created_at DESC").limit(5)
        @total_publishers = Publisher.all.count
        @new_publishers = Publisher.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count
        @total_categories = Category.all.count
        @new_categories = Category.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count
        
    end
end
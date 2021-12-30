class Admin::DashboardController < AdminController
    before_action :authenticate_user!
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
        @total_borrows = Borrow.count
        @borrow_in_day = Borrow.where(borrowed_date: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count
        @return_in_day = Borrow.where(updated_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, status: "returned").count
        @total_proceeds_in_day = Borrow.proceeds_in_day
        @exist_quantity_book = Book.exist_quantity
        @warning_quantity_book = Book.where("quantity_in_stock < '20'").count
        @authors_list = Author.all.order("created_at DESC").limit(5)
        @borrows_per_month = Borrow.count_by_group_month
        @top_books = Borrow.get_top_three_book
        @top_users = Borrow.get_top_three_user
        @top_authors = Borrow.get_top_three_author
        @user_per_month = User.count_user_by_month
    end
end
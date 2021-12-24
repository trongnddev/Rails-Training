require "test_helper"

class BorrowTest < ActiveSupport::TestCase

    setup do
        @user_attrs =  {email: "user_a@email.com", password: "111111", password_confirmation: "111111", role: "staff"}
        @cate_attrs = Category.create(name: "ASaaa")
        @book_atrrs = {category_id: @cate_attrs.id, name: "Anh đi"} 
      end
    

    test "borrow is valid" do
        user = User.create(@user_atrrs)
        cate = Category.create(name: "add")
        book = Book.create(category_id: cate.id, name: "ABS")
        assert borrow = Borrow.create(user_id: user.id, book_id: book.id)
        # assert borrow.invalid?
        # assert borrow.error[:book_id].any?

    end 


end 
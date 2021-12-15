require 'test_helper'

class BookTest < ActiveSupport::TestCase
    test "Book name is not null" do
        new_book = Book.new
        assert new_book.invalid?
        assert new_book.errors[:name].any?
    end

    test "Book name valid" do
        new_book = Book.new(:name => "123")
        assert new_book.invalid?
        assert new_book.errors[:name].any? 
    end

    test "Borrow fee greater than 0" do
        new_book = Book.new(:borrow_fee => -1)
        assert new_book.invalid?
        assert new_book.errors[:borrow_fee].any?
    end 
end
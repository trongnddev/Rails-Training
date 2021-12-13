require 'test_helper'

class AuthorTest < ActiveSupport::TestCase
    test "Author is not null" do 
        new_author = Author.new 
        assert new_author.invalid?
        assert new_author.errors[:author_name].any?
    end 

    test "Author name valid" do 
        new_author = Author.new(:author_name => "thien 123")
        assert new_author.invalid?
        assert new_author.errors[:author_name].any? 
    end
end
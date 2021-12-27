require 'test_helper'

class UserTest < ActiveSupport::TestCase

    setup do
        @attrs = { email: "something@here.com", password: "123456" }
      end
    
    test "user email must be unique" do
        assert User.create(@attrs)
        assert user = User.new(@attrs)
        assert user.invalid?
        assert user.errors.include?(:email)
    end
      
    test "email sign up is not null" do 
        user = User.new 
        assert user.invalid?
        assert user.errors[:email].any?
        
    end 

    test "email sign up is valid " do
        user = User.new(@attrs)
        
        assert user.save 
    end

    test "email sign up is invalid " do
        user = User.new(:email => "aa")
        assert user.invalid?
        assert user.errors[:email].any?
    end

    test "password must be more than 6 chars" do
        user = User.new(:email => "a@a.com", :password => "12")
        assert user.invalid?
        assert user.errors[:password].any?
    end
end

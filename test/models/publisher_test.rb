require 'test_helper'

class PublisherTest < ActiveSupport::TestCase
    test "Is not null" do 
        new_publisher = Publisher.new
        assert new_publisher.invalid?
        assert new_publisher.errors[:publisher_name].any?
    end

    test "Valid publisher name" do 
        new_publisher = Publisher.new(:publisher_name => "NXB 187")
        assert new_publisher.invalid?
        assert new_publisher.errors[:publisher_name].any?
    end

    test "Unique publisher name" do
        new_publisher = Publisher.new(:publisher_name => "OXFORD")
        assert !new_publisher.save
        assert_equal "has already been taken",new_publisher.errors[:publisher_name].join('')
    end
end
require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
    test "Review not null" do 
        new_review = Review.new 
        assert new_review.invalid?
        assert new_review.errors[:comment].any?
        assert new_review.errors[:star].any?
    end
end
require File.expand_path("../../test_helper", __FILE__)

class CategoryTest < ActiveSupport::TestCase
  test "Name not null" do
    category = Category.new
    assert category.invalid?
    assert category.errors[:name].any?
  end

  test "Is uniquess" do 
   new_category = Category.new(:name => "Romantic", :description => "abcd")
   assert !new_category.save 
   assert_equal "has already been taken",new_category.errors[:name].join('')
  end

  test "Is valid name" do 
    new_category = Category.new(:name => "Thien 123")
    assert new_category.invalid?
    assert new_category.errors[:name].any?
  end
end

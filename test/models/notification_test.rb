require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end


  setup do
    @user_attrs =  {email: "user_a@email.com", password: "111111", password_confirmation: "111111"}
  end

  test "Notification is valid" do
      assert user = User.create(@user_atrrs)
      
      assert Notification.create(user_id: user.id,  message:  "test notification")
      # assert notification.save 
      
  end

  test "Notification must be have message" do
      user = User.create(@user_atrrs)
      notification = Notification.new(user_id: user.id)
      assert notification.invalid?
      assert notification.errors[:message].any?
  end 
  
end

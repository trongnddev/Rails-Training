class Notification < ApplicationRecord
  belongs_to :user
  

  def self.update_seen(id)
    notification = Notification.find(id)
    notification.update_column(:seen, true)
  end

  def self.count_notice
    Notification.where(:message => "for staff").count
  end


  def self.count_notice_user(user_id)
    Notification.where(:user => user_id, :seen => false).count
  end
  
end

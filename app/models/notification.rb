class Notification < ApplicationRecord
  belongs_to :user
  

  def self.update_seen(id)
    notification = Notification.find(id)
    notification.update_column(:seen, true)
  end

  
end

class Review < ApplicationRecord
    belongs_to :book, optional: true
    belongs_to :user, optional: true
    validates :comment, :star, presence: true
    def username
      self.user.email.split("@")[0].capitalize
    end
end

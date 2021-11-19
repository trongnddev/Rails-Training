class Borrow < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :book, optional: true


    def self.search(search)
        if search
            where(status: "#{search}")
        else
            all
        end
    end
end

class Book < ApplicationRecord
    has_one_attached :image
    validates :name, :description, :published_date, :publisher, :borrow_fee,:quantity,:quantity_in_stock , presence: true
end

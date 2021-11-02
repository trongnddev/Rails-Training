class Book < ApplicationRecord
    has_one_attached :image
    validates :publisher, numericality: false
end

class Publisher < ApplicationRecord
  has_many :books
  validates :publisher_name, presence: true, format: { with: /\A[[:alpha:][:blank:]]+\z/ }
end

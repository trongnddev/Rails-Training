class Publisher < ApplicationRecord
  has_many :books
  validates :publisher_name, presence: true, uniqueness: true, format: { with: /\A[[:alpha:][:blank:]]+\z/ }
  before_create {|publisher| publisher.publisher_name = publisher.publisher_name.upcase}
end

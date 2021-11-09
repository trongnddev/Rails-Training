class AuthorBook < ApplicationRecord
  belongs_to :author, optional: true
  belongs_to :book, optional: true
  accepts_nested_attributes_for :book, :author
end

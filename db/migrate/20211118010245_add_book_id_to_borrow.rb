class AddBookIdToBorrow < ActiveRecord::Migration[6.1]
  def change
    add_reference :borrows, :book, foreign_key: true
  end
end

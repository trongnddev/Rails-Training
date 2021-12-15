class ChangeNameBookidToBorrowId < ActiveRecord::Migration[6.1]
  def change
    rename_column :notifications, :book_id, :borrow_id
  end
end

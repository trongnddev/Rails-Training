class AddTotalBorrowToBook < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :total_borrow, :integer
  end
end

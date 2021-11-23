class ChangeDataTypeFromBorrow < ActiveRecord::Migration[6.1]
  def change
    change_column :borrows, :borrowed_date, :date
  end
end

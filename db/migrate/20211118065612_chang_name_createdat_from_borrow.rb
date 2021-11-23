class ChangNameCreatedatFromBorrow < ActiveRecord::Migration[6.1]
  def change
    rename_column :borrows, :created_at, :borrowed_date
  end
end

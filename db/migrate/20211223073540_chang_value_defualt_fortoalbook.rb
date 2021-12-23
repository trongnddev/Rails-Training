class ChangValueDefualtFortoalbook < ActiveRecord::Migration[6.1]
  def change
    change_column :books, :total_borrow, :integer, :default => 0
  end
end

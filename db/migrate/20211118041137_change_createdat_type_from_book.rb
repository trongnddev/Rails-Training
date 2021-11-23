class ChangeCreatedatTypeFromBook < ActiveRecord::Migration[6.1]
  def change
    change_column :books, :created_at, :date
  end
end

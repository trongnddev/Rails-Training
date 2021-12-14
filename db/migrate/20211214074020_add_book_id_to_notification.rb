class AddBookIdToNotification < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :book_id, :integer
  end
end

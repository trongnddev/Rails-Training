class AddUserIdToBorrow < ActiveRecord::Migration[6.1]
  def change
    add_reference :borrows, :user, foreign_key: true
  end
end

class RemoveLastnamFromAuthor < ActiveRecord::Migration[6.1]
  def change
    remove_column :authors, :lastname, :string
  end
end

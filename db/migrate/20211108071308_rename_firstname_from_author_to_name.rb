class RenameFirstnameFromAuthorToName < ActiveRecord::Migration[6.1]
  def change
    rename_column :authors, :firstname, :author_name
  end
end

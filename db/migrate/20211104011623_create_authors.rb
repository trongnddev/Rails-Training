class CreateAuthors < ActiveRecord::Migration[6.1]
  def change
    create_table :authors do |t|
      t.string :firstname
      t.string :lastname
      t.date :birthday

      t.timestamps
    end
  end
end

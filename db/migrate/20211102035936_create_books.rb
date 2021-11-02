class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :name
      t.text :description
      t.date :published_date
      t.integer :publisher
      t.float :borrow_fee
      t.integer :quantity
      t.integer :quantity_in_stock

      t.timestamps
    end
  end
end

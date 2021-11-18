class CreateBorrows < ActiveRecord::Migration[6.1]
  def change
    create_table :borrows do |t|
      t.date :returned_date
      t.integer :appointment_returned_date
      t.string :status

      t.timestamps
    end
  end
end

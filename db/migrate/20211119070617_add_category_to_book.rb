class AddCategoryToBook < ActiveRecord::Migration[6.1]
  def change
    add_reference :books, :category, foreign_key: true
  end
end

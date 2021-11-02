class ChangePublisherToBeStringInBooks < ActiveRecord::Migration[6.1]
  def change
    change_column :books, :publisher, :string
  end
end

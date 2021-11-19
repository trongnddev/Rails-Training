class AddPenaltyFeeToBorrow < ActiveRecord::Migration[6.1]
  def change
    add_column :borrows, :penalty_fee, :integer
  end
end

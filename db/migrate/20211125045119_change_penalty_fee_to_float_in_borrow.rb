class ChangePenaltyFeeToFloatInBorrow < ActiveRecord::Migration[6.1]
  def change
    change_column :borrows, :penalty_fee, :float
  end
end

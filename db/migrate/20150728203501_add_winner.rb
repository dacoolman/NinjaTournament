class AddWinner < ActiveRecord::Migration
  def change
  	add_column :results, :winner_A_id, :integer
  	add_column :results, :winner_B_id, :integer
  end
end

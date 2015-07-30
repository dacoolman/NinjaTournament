class AddAllColumns < ActiveRecord::Migration
  def change
  	remove_column :tournaments, :winner_B
  	add_column :tournaments, :winner_B_id, :integer
  	remove_column :results, :Player_1A
  	add_column :results, :Player_1A_id, :integer
  	remove_column :results, :Player_1B
  	add_column :results, :Player_1B_id, :integer
  	remove_column :results, :Player_2A
  	add_column :results, :Player_2A_id, :integer
   	remove_column :results, :Player_2B
  	add_column :results, :Player_2B_id, :integer	
    remove_column :participants, :Player_A
  	add_column :participants, :Player_A_id, :integer	
    remove_column :participants, :Player_B
  	add_column :participants, :Player_B_id, :integer	
  end
end

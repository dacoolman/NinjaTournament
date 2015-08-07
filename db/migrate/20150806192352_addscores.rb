class Addscores < ActiveRecord::Migration
  def change
  	add_column :results, :Player_1_score, :integer
	add_column :results, :Player_2_score, :integer
  end
end

class AddidColumns < ActiveRecord::Migration
  def change
  	remove_column :tournaments, :winner_A
  	add_column :tournaments, :winner_A_id, :integer

  end
end

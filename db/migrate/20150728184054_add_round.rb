class AddRound < ActiveRecord::Migration
  def change
  	add_column :results, :round, :integer
  end
end

class AddMoreColumns < ActiveRecord::Migration
  def change
  add_column :results, :order, :integer
  add_column :results, :Player_1A_rating, :integer
  add_column :results, :Player_1B_rating, :integer
  add_column :results, :Player_2A_rating, :integer
  add_column :results, :Player_2B_rating, :integer

  end
end

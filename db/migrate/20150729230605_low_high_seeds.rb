class LowHighSeeds < ActiveRecord::Migration
  def change
  	add_column :results, :low_seed, :integer
  	add_column :results, :high_seed, :integer
  end
end

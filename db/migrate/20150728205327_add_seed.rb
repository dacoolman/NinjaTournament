class AddSeed < ActiveRecord::Migration
  def change
  	add_column :participants, :seed, :integer
  end
end

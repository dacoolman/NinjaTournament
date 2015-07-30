class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :singles_total_wins
      t.integer :singles_total_losses
      t.integer :singles_total_games
      t.integer :singles_opponent_ratings
       t.integer :doubles_total_wins
      t.integer :doubles_total_losses
      t.integer :doubles_total_games
      t.integer :doubles_opponent_ratings     
      t.integer :singles_rating
      t.integer :doubles_rating

      t.timestamps null: false
    end
  end
end

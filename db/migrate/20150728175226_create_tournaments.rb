class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.string :game
      t.boolean :singles?
      t.boolean :finished
      t.integer :winner_A, index: true, foreign_key: true
      t.integer :winner_B, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

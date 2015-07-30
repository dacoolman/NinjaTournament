class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :Player_1A, index: true, foreign_key: true
      t.integer :Player_1B, index: true, foreign_key: true
      t.integer :Player_2A, index: true, foreign_key: true
      t.integer :Player_2B, index: true, foreign_key: true
      t.references :tournament, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

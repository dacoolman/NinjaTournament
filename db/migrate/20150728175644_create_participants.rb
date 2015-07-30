class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.integer :Player_A, index: true, foreign_key: true
      t.integer :Player_B, index: true, foreign_key: true
      t.references :tournament
      t.timestamps null: false
    end
  end
end

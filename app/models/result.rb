class Result < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :Player_1A, :class_name => 'User'
  belongs_to :Player_1B, :class_name => 'User'
  belongs_to :Player_2A, :class_name => 'User'
  belongs_to :Player_2B, :class_name => 'User'
   belongs_to :winner_A, :class_name => 'User'
  belongs_to :winner_B, :class_name => 'User'
  validates :round, presence: true
end

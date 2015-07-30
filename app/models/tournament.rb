class Tournament < ActiveRecord::Base
validates :name, :game, presence: true
belongs_to :winner_A, :class_name => 'User'
belongs_to :winner_B, :class_name => 'User'
end

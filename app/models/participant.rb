class Participant < ActiveRecord::Base
	belongs_to :tournament
	belongs_to :Player_A, :class_name => 'User'
	belongs_to :Player_B, :class_name => 'User'
	belongs_to :tournament
	validates :seed, presence: true
end

class User < ActiveRecord::Base
has_many :participants
has_many :results
has_many :tournaments
validates :name, uniqueness: true, presence: true
end

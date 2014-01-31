class Event < ActiveRecord::Base

	belongs_to :game
	has_many :records
	has_and_belongs_to_many :teams
	
end

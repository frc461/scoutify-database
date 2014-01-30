class Game < ActiveRecord::Base

	has_many :events
	has_many :records
	
end

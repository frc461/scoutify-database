class Game < ActiveRecord::Base

	belongs_to :event
	has_many :records
	
end

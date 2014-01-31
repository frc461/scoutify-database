class Match < ActiveRecord::Base

	has_many :records
	belongs_to :event

end

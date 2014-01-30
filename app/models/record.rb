class Record < ActiveRecord::Base

	belongs_to :game
	belongs_to :team
	belongs_to :user

end

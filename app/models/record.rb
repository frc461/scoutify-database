class Record < ActiveRecord::Base
	serialize :data

	belongs_to :match
	belongs_to :team
	belongs_to :user
end

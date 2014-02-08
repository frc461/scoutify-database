class Team < ActiveRecord::Base
	require "net/http"
	include TBA

	validates :number, uniqueness: true

	has_many :records
	has_and_belongs_to_many :events

	def tba_update(key = nil)
		key ||= "frc" + number.to_s
		res = tba_request :team, key

		tba_error(res.uri, res.code, res.body) unless res.is_a?(Net::HTTPSuccess)

		json = MultiJson.load(res.body)

		self.name = json["nickname"]
		self.number = json["team_number"]
		self.save
	end
end

class Team < ActiveRecord::Base

	require "net/http"

	validates :number, uniqueness: true

	has_many :records
	has_and_belongs_to_many :events

	def tba_update(key = nil)
		key ||= "frc" + number.to_s
		uri = URI("http://www.thebluealliance.com/api/v1/team/details")
		params = { team: key }
		uri.query = URI.encode_www_form(params)
		res = Net::HTTP.get_response(uri)
		unless res.is_a?(Net::HTTPSuccess)
			puts res.uri
			puts res.code
			puts res.body
			raise "Error with TBA API"
		end
		json = MultiJson.load(res.body)
		self.name = json["nickname"]
		self.number = json["team_number"]
		self.save
	end

end

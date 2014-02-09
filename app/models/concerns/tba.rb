module TBA
	extend ActiveSupport::Concern
	require "net/http"

	TBA_BASE_URL = "http://www.thebluealliance.com"
	TBA_REQUEST_TYPE_TABLE = {
		teams: "/api/v1/teams/show",
		team: "/api/v1/team/details",
		year: "/api/v1/events/list",
		event: "/api/v1/event/details",
		match: "/api/v1/match/details",
		matches: "/api/v1/match/details"
	}
	
	def tba_request(request_type, key)
		uri = URI.parse TBA_BASE_URL + TBA_REQUEST_TYPE_TABLE[request_type]
		params = { request_type => key }

		uri.query = URI.encode_www_form params

		req = Net::HTTP::Get.new uri
		req.add_field "X-TBA-App-Id", "frc461:scoutify-database:" + ScoutifyDatabase::VERSION

		res = Net::HTTP.new(uri.host, uri.port).start do |http|
			http.request req
		end

		return res
	end
	
	def tba_error(uri, code, body)
		raise "Error with TBA API:\nURI: #{uri}\nURI Length: #{uri.to_s.length}\nCode: #{code}\nBody: #{body}"
	end
end

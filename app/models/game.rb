class Game < ActiveRecord::Base
	require "net/http"

	has_many :events
	has_many :records

	def tba_update
		uri = URI("http://www.thebluealliance.com/api/v1/events/list")
		params = { year: self.year.to_s }
		
		uri.query = URI.encode_www_form params
		res = Net::HTTP.get_response uri
		
		raise "Error with TBA API:\nURI: #{res.uri}\nCode: #{res.code}\nBody: #{res.body}" unless res.is_a?(Net::HTTPSuccess)
		
		MultiJson.load res.body.each do |event_json|
			event = events.where(name: event_json["name"]).first
			event ||= Event.create
			event.tba_update event_json["key"]
		end
	end
end

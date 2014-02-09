class Game < ActiveRecord::Base
	require "net/http"
	include TBA

	has_many :events
	has_many :records

	def tba_update
		res = tba_request :year, self.year.to_s
		
		tba_error(res.uri, res.code, res.body) unless res.is_a?(Net::HTTPSuccess)
		
		(MultiJson.load res.body).each do |event_json|
			event = events.where(name: event_json["name"]).first
			event ||= Event.create
			event.tba_update event_json["key"]
		end
		self
	end
end

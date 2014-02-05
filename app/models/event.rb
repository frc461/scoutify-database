class Event < ActiveRecord::Base
	require "net/http"
	include Error

	belongs_to :game
	has_many :matches
	has_and_belongs_to_many :teams

	def tba_update(key)
		uri = URI("http://www.thebluealliance.com/api/v1/event/details")
		params = { event: key }
		
		uri.query = URI.encode_www_form(params)
		res = Net::HTTP.get_response(uri)
		
		class.tba_error(res.uri, res.code, res.body) unless res.is_a?(Net::HTTPSuccess)
		
		json = MultiJson.load(res.body)

		self.name = json["name"]
		self.game = Game.where(year: json["year"]).first
		self.game ||= Game.create(year: json["year"])
		self.save

		unless json["teams"].empty?
			teams_uri = URI("http://www.thebluealliance.com/api/v1/teams/show")
			teams_params = { teams: json["teams"].join(",") }
			
			teams_uri.query = URI.encode_www_form teams_params
			teams_res = Net::HTTP.get_response teams_uri
			
			class.tba_error(teams_res.uri, teams_res.code, teams_res.body) unless teams_res.is_a?(Net::HTTPSuccess)
			
			teams_json = MultiJson.load teams_res.body

			json["teams"].each do |team_key|
				team_number = (teams_json.detect { |t| t["key"] == team_key })["team_number"]
				team = Team.where(number: team_number).first
				
				unless team
					team = Team.create
					team.tba_update team_key
				end
				
				self.teams << team unless self.teams.include? team
			end

			json["matches"].each do |match_key|
				match = self.matches.where(number: match_key.split("_")[1]).first
				match ||= Match.create(event_id: id)
				
				match.tba_update(match_key, teams_json)
			end
		end
	end
end

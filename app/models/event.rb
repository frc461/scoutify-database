class Event < ActiveRecord::Base
	require "net/http"
	include TBA

	belongs_to :game
	has_many :matches
	has_and_belongs_to_many :teams

	def tba_update(key)
		res = tba_request :event, key

		tba_error(res.uri, res.code, res.body) unless res.is_a?(Net::HTTPSuccess)

		json = MultiJson.load(res.body)

		self.name = json["name"]
		self.game = Game.where(year: json["year"]).first
		self.game ||= Game.create(year: json["year"])
		self.save

		unless json["teams"].empty?
			teams_res = tba_request :teams, json["teams"].join(",")

			tba_error(teams_res.uri, teams_res.code, teams_res.body) unless teams_res.is_a?(Net::HTTPSuccess)

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

			matches_csv = json["matches"][0]
			matches_json = []
			json["matches"].drop(1).each do |match_key|
				if (TBA_BASE_URL +
				    TBA_REQUEST_TYPE_TABLE[:matches] +
				    Rack::Utils.escape(matches_csv) +
				    "%2C" +
				    match_key).length > 2000

					matches_res = tba_request :matches, matches_csv
					tba_error(matches_res.uri, matches_res.code, matches_res.body) unless matches_res.is_a?(Net::HTTPSuccess)
					matches_json += MultiJson.load matches_res.body
					matches_csv = ""
				else
					matches_csv += ","
				end
				matches_csv += match_key
			end

			matches_res = tba_request :matches, matches_csv
			tba_error(matches_res.uri, matches_res.code, matches_res.body) unless matches_res.is_a?(Net::HTTPSuccess)
			matches_json += MultiJson.load matches_res.body

			json["matches"].each do |match_key|
				match = self.matches.where(number: match_key.split("_")[1]).first
				match ||= Match.create(event_id: id)

				match.tba_update(match_key, teams_json, matches_json)
			end
		end
		self
	end
end

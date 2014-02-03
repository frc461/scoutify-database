class Match < ActiveRecord::Base
	require 'net/http'

	has_many :records
	belongs_to :event

	def tba_update(key, teams_json = nil)
		uri = URI("http://www.thebluealliance.com/api/v1/match/details")
		params = { match: key }

		uri.query = URI.encode_www_form params
		res = Net::HTTP.get_response uri

		raise "Error with TBA API:\nURI: #{res.uri}\nCode: #{res.code}\nBody: #{res.body}" unless res.is_a?(Net::HTTPSuccess)

		json = MultiJson.load res.body

		self.red_score  = json[0]["alliances"]["red"]["score"]
		self.blue_score = json[0]["alliances"]["blue"]["score"]
		self.number = json[0]["key"].split("_")[1]
		self.save

		unless teams_json
			teams_uri = URI("http://www.thebluealliance.com/api/v1/teams/show")
			teams_params = { teams: json[0]["team_keys"].join(",") }

			teams_uri.query = URI.encode_www_form teams_params
			teams_res = Net::HTTP.get_response teams_uri

			raise "Error with TBA API:\nURI: #{teams_res.uri}\nCode: #{teams_res.code}\nBody: #{teams_res.body}" unless teams_res.is_a?(Net::HTTPSuccess)

			teams_json = MultiJson.load teams_res.body
		end

		["red", "blue"].each do |team_color|
			position_base_num = (team_color == "blue") ? 0 : 3
			json[0]["alliances"][team_color]["teams"].map do |team_key|
				# sometimes TBA uses team keys like "frc973B", ignore these
				if teams_json.detect { |t| t["key"] == team_key }
					team_number = (teams_json.detect { |t| t["key"] == team_key })["team_number"]
					team = Team.where(number: team_number).first
					unless team
						team = Team.create
						team.tba_update team_key
					end
				end
				query_string = "" # scope?
				if team_color == "red"
					query_string = "position < 3 AND team_id == ?"
				elsif team_color == "blue"
					query_string = "position >= 3 AND team_id == ?"
				end
				if records.where(query_string, (team && team.id)).empty?
					for i in position_base_num..(position_base_num + 2) do
						if records.where(position: i).empty?
							Record.create match_id: id, position: i, team_id: (team && team.id)
							break
						end
					end
				end
			end
		end
	end
end
# It's like LISP parentheses

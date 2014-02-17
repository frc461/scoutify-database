class Game < ActiveRecord::Base
	require "net/http"
	include TBA

	serialize :opr, Hash

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

	def opr_update
		ared = []
		ablue = []
		scorered = []
		scoreblue = []

		teamref = events.map(&:teams).flatten.uniq.map(&:number)
		teams = teamref.length

		events.map(&:matches).flatten.each do |match|
			catch :teams_incomplete do
				aredrow = Array.new teams, 0
				abluerow = Array.new teams, 0

				match.records.each do |record|
					throw :teams_incomplete unless record.team
					index = teamref.index record.team.number
					if record.position < 3
						aredrow[index] = 1
					elsif record.position >= 3
						abluerow[index] = 1
					end
				end

				ared << aredrow
				ablue << abluerow
				scorered << [match.red_score]
				scoreblue << [match.blue_score]
			end
		end

		scoreset = OPRCalc::ScoreSet.new (Matrix.rows ared), (Matrix.rows ablue), (Matrix.rows scorered), (Matrix.rows scoreblue)

		puts "Calculating OPR..."

		scoreset.opr.each_with_index do |opr_thing, index|
			puts teamref[index].to_s + ": " + opr_thing.to_s
			self.opr[teamref[index]] = opr_thing
		end
		self.save
	end
end

desc "Update game"
task :update_game => :environment do
  game = Game.find(ENV["GAME_ID"])
  game.tba_update
end

desc "Update event"
task :update_event => :environment do
  event = Event.find(ENV["EVENT_ID"])
  event.tba_update
end

desc "Update match"
task :update_match => :environment do
  match = Match.find(ENV["MATCH_ID"])
  match.tba_update
end

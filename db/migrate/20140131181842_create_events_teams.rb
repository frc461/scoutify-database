class CreateEventsTeams < ActiveRecord::Migration
  def change
    create_table :events_teams do |t|
      t.integer :event_id
      t.integer :team_id
    end
  end
end

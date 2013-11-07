class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.text :data
      t.integer :team_id
      t.integer :event_id
      t.integer :user_id

      t.timestamps
    end
  end
end

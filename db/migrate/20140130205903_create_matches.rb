class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :event_id
      t.text :match_number

      t.timestamps
    end
  end
end

class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :year
      t.string :name

      t.timestamps
    end
  end
end

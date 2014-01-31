class AddMatchIdToRecord < ActiveRecord::Migration
  def change
    add_column :records, :match_id, :integer
  end
end

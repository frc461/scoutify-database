class RemoveEventIdFromRecord < ActiveRecord::Migration
  def change
	  remove_column :records, :event_id
  end
end

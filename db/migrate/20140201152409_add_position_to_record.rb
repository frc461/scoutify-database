class AddPositionToRecord < ActiveRecord::Migration
  def change
    add_column :records, :position, :integer
  end
end

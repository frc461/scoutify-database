class ChangeMatchMatchNumberToNumber < ActiveRecord::Migration
  def change
	  rename_column :matches, :match_number, :number
  end
end

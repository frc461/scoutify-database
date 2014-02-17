class AddOprToGame < ActiveRecord::Migration
  def change
    add_column :games, :opr, :text
  end
end

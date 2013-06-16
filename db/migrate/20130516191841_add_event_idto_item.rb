class AddEventIdtoItem < ActiveRecord::Migration
  def up
  	add_column :items, :event_id, :integer
  end

  def down
  	remove_column :items, :event_id
  end
end

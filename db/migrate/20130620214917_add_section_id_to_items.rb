class AddSectionIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :section_id, :integer
  end
end

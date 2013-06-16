class ChangeParentToParentId < ActiveRecord::Migration
  def change
    rename_column :items, :parent, :parent_id
  end
end

class AddChildToItem < ActiveRecord::Migration
  def change
    add_column :items, :child, :integer
  end
end

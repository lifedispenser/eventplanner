class AddRankedToItem < ActiveRecord::Migration
  def change
    add_column :items, :ranked, :integer
  end
end

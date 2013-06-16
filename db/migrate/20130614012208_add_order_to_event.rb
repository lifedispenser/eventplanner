class AddOrderToEvent < ActiveRecord::Migration
  def change
    add_column :events, :order, :string
  end
end

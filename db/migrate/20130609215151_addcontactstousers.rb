class Addcontactstousers < ActiveRecord::Migration
  def change
    add_column :users, :contacts, :text
  end
end

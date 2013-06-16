class Addcontactsupdatedtousers < ActiveRecord::Migration
  def change
    add_column :users, :contacts_updated, :datetime
  end
end

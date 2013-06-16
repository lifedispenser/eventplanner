class Fixcolumntypeinitems < ActiveRecord::Migration
  def up
    change_column :items, :person_in_charge, :string
  end

  def down
    change_column :items, :person_in_charge, :integer
  end
end

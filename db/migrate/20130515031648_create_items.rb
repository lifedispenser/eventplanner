class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :description
      t.string :result
      t.integer :person_in_charge
      t.date :completed_by
      t.integer :days_before
      t.string :status
      t.integer :parent

      t.timestamps
    end
  end
end

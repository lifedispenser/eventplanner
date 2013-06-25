class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :name
      t.text :description
      t.integer :confirm
      t.string :order

      t.timestamps
    end
  end
end

class AddTemplateToEvents < ActiveRecord::Migration
  def change
    add_column :events, :template, :integer
  end
end
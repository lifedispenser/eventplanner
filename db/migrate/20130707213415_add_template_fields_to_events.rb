class AddTemplateFieldsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :template_title, :string
    add_column :events, :template_desc, :text
  end
end

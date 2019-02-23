class DropResourceThemes < ActiveRecord::Migration[4.2]
  def change
  	drop_table :resource_themes
  	add_column :documents, :subject_id, :integer, index: true
  end
end

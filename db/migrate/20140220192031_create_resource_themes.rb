class CreateResourceThemes < ActiveRecord::Migration[4.2]
  def change
    create_table :resource_themes do |t|
      t.belongs_to :resource, index: true
      t.belongs_to :theme, index: true

      t.timestamps null: false
    end
  end
end

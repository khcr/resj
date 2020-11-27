class CreateAffiliations < ActiveRecord::Migration[4.2]
  def change
    create_table :affiliations do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end

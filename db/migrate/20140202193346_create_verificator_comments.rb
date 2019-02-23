class CreateVerificatorComments < ActiveRecord::Migration[4.2]
  def change
    create_table :verificator_comments do |t|
      t.text :content
      t.belongs_to :user, index: true
      t.belongs_to :card, index: true

      t.timestamps null: false
    end
  end
end

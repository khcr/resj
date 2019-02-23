class DropVerificatorComments < ActiveRecord::Migration[4.2]
  def change
    drop_table :verificator_comments
  end
end

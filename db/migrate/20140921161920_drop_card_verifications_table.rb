class DropCardVerificationsTable < ActiveRecord::Migration[4.2]
  def change
  	drop_table :card_verifications
  end
end

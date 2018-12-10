class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.string :country_code, null: false, index: true
      t.string :line1
      t.string :line2
      t.string :city
      t.string :state
      t.string :postal_code
      t.boolean :active, index: true, null: false, default: true
      t.timestamps null: false
    end
  end
end

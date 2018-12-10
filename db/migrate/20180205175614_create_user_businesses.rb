class CreateUserBusinesses < ActiveRecord::Migration
  def change
    create_table :user_businesses do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.string :name, null: false
      t.string :tax_id

      t.string :country_code, index: true
      t.string :line1
      t.string :line2
      t.string :city
      t.string :state
      t.string :postal_code

      t.timestamps null: false
    end
  end
end

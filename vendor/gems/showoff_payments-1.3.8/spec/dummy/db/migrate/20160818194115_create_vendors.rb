class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :email, null: false, index: true

      t.timestamps null: false
    end
  end
end

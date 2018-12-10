class AddColumnsToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string  :location
      t.string  :description
      t.string  :school
      t.string  :work
      t.attachment :image
      t.string :gender
      t.boolean :notifications_enabled, default: true, null: false
      t.string :country_code, index: true
      t.string :tos_acceptance_ip, index: true
      t.timestamp :tos_acceptance_timestamp, index: true
      t.integer :account_type, index: true
      t.boolean :has_bank_account, default: false, index: true, null: false
      t.boolean :has_payment_method, default: false, index: true, null: false
      t.boolean :active, default: true, null: false, index: true
      t.integer :user_type, index: true, null: false, default: 0

      t.string  :business_name

    end
  end
end
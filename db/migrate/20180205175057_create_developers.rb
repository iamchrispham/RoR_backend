class CreateDevelopers < ActiveRecord::Migration
  def change
    create_table :developers do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Model Specific
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.attachment :image
      t.boolean :active, index: true, null: false, default: true
      t.timestamp :last_active, index: true

      t.timestamps null: false
    end

    add_index :developers, :email,                unique: true
    add_index :developers, :reset_password_token, unique: true
  end
end

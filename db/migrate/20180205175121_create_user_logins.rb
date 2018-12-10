class CreateUserLogins < ActiveRecord::Migration
  def change
    create_table :user_logins do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.string :ip
      t.text :user_agent
      t.string :location
      t.float :latitude, index: true
      t.float :longitude, index: true
      t.text :request
      t.text :isp
      t.integer :application_id, index: true
      t.integer  :access_token_id, index: true
      t.timestamps null: false
    end
  end
end

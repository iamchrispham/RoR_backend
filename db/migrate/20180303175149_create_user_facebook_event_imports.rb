class CreateUserFacebookEventImports < ActiveRecord::Migration
  def change
    create_table :user_facebook_event_imports do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.text :access_token, null: false
      t.integer :status, null: false, index: true, default: 0
      t.integer :imported_count, index: true, default: 0, null: false
      t.integer :failed_count, index: true, default: 0, null: false

      t.timestamps null: false
    end
  end
end

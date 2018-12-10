class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :user, index: true, foreign_key: true
      t.string :title, null: false, index: true
      t.text :description
      t.timestamp :time, null: false
      t.timestamp :date, null: false
      t.boolean :eighteen_plus, default: false, null: false, index: true

      #locations
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.string :address, default: '', null: false
      t.string :country_code, index: true
      t.string :country, default: ''
      t.string :city, default: ''
      t.string :state, default: ''
      t.string :postal_code, default: ''


      t.boolean :private_event, null: false, default: false

      t.text :categories, null: false

      t.boolean :event_forwarding, null: false, default: true
      t.boolean :allow_chat, null: false, default: true
      t.boolean :show_timeline, null: false, default: true

      t.text :bring

      t.timestamp :inactive_at, null: true, index: true
      t.boolean :active, null: false, index: true, default: true

      t.timestamps null: false
    end
  end
end

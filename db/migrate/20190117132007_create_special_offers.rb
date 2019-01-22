# frozen_string_literal: true

class CreateSpecialOffers < ActiveRecord::Migration
  def change
    create_table :special_offers do |t|
      t.citext :title, null: false, index: { unique: true }
      t.citext :details
      t.timestamp :publish_on
      t.timestamp :starts_at
      t.timestamp :ends_at
      t.boolean :active, null: false, default: true
      t.attachment :image
      t.timestamps null: false
    end
  end
end

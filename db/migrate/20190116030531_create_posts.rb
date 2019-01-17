# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.citext :title, null: false, index: { unique: true }
      t.citext :details, null: false

      t.references :postable, polymorphic: true, index: true

      t.boolean :active, null: false, default: true

      t.attachment :image

      t.timestamps null: false
    end
  end
end

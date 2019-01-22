# frozen_string_literal: true

class CreateLikedOffers < ActiveRecord::Migration
  def change
    create_table :liked_offers do |t|
      t.references :special_offer, null: false
      t.references :user, null: false
      t.references :group, null: false

      t.index %i[user_id special_offer_id group_id], unique: true

      t.timestamps null: false
    end

    add_foreign_key 'liked_offers', 'special_offers',
                    name: 'liked_offers_special_offer_fk',
                    on_delete: :cascade

    add_foreign_key 'liked_offers', 'users',
                    name: 'liked_offers_user_id_fk',
                    on_delete: :cascade

    add_foreign_key 'liked_offers', 'groups',
                    name: 'liked_offers_group_id_fk',
                    on_delete: :cascade
  end
end

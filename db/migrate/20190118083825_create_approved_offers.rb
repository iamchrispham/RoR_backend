# frozen_string_literal: true

class CreateApprovedOffers < ActiveRecord::Migration
  def change
    create_table :approved_offers do |t|
      t.references :special_offer, null: false
      t.references :group, null: false
      t.references :user, null: false

      t.index %i[group_id special_offer_id], unique: true
      t.index %i[user_id group_id special_offer_id], name: :index_approved_offers_user_id_group_id_special_offer_id

      t.timestamps null: false
    end

    add_foreign_key 'approved_offers', 'special_offers',
                    name: 'approved_offers_special_offer_fk',
                    on_delete: :cascade

    add_foreign_key 'approved_offers', 'users',
                    name: 'approved_offers_user_id_fk',
                    on_delete: :cascade

    add_foreign_key 'approved_offers', 'groups',
                    name: 'approved_offers_group_id_fk',
                    on_delete: :cascade
  end
end

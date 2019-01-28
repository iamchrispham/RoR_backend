# frozen_string_literal: true

class AddActiveToApprovedOffers < ActiveRecord::Migration
  def change
    add_column :approved_offers, :active, :boolean, null: false, default: false
  end
end

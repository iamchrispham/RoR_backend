# frozen_string_literal: true

class AddAdvertiserLocationToSpecialOffer < ActiveRecord::Migration
  def change
    add_column :special_offers, :advertiser, :string, null: false, default: ''
    add_column :special_offers, :location, :string
  end
end

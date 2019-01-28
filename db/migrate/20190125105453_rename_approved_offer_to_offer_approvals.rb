# frozen_string_literal: true

class RenameApprovedOfferToOfferApprovals < ActiveRecord::Migration
  def change
    rename_table :approved_offers, :offer_approvals
  end
end

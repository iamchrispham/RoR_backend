# frozen_string_literal: true

class AddSocialLinksToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :phone, :string, null: false, default: ''
    add_column :groups, :email, :string, null: false, default: ''
    add_column :groups, :website, :string, null: false, default: ''

    add_column :groups, :facebook_profile_link, :string, default: ''
    add_column :groups, :linkedin_profile_link, :string, default: ''
    add_column :groups, :instagram_profile_link, :string, default: ''
    add_column :groups, :snapchat_profile_link, :string, default: ''
  end
end

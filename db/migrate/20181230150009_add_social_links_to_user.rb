class AddSocialLinksToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook_profile_link, :string
    add_column :users, :linkedin_profile_link, :string
    add_column :users, :instagram_profile_link, :string
    add_column :users, :snapchat_profile_link, :string
  end
end

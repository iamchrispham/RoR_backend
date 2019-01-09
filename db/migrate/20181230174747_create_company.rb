class CreateCompany < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.belongs_to :user, null: false

      t.string :title, null: false, index: true
      t.text :description
      t.string :phone_number
      t.string :email
      t.string :facebook_profile_link
      t.string :linkedin_profile_link
      t.string :instagram_profile_link
      t.string :snapchat_profile_link
      t.string :website_link
      t.string  :location

      t.attachment :image

      t.timestamps null: false
    end
  end
end

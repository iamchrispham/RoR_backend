class CreateUsersFollowedCompanies < ActiveRecord::Migration
  def change
    create_table :users_followed_companies do |t|
      t.belongs_to :user, index: true
      t.references :company, index: true
    end
  end
end

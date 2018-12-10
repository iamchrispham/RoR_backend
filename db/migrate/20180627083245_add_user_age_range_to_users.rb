class AddUserAgeRangeToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :user_age_range, index: true, foreign_key: true
  end
end

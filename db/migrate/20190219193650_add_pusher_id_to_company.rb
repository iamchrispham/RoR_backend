class AddPusherIdToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :pusher_id, :string
  end
end

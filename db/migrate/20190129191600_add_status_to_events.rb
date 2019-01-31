class AddStatusToEvents < ActiveRecord::Migration
  def change
    add_column :events, :review_status, :integer
  end
end

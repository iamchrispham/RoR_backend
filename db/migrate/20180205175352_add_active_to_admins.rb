class AddActiveToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :active, :boolean, default: true, null: false
    add_index :admins, :active
  end
end

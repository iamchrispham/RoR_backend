class AddStatusesToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :active, :boolean, default: :true, allow_nil: false
    add_column :companies, :suspended, :boolean, default: :false, allow_nil: false
  end
end

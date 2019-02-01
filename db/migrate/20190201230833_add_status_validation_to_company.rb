class AddStatusValidationToCompany < ActiveRecord::Migration
  def change
    change_column :companies, :active, :boolean, null: false
    change_column :companies, :suspended, :boolean, null: false
  end
end

class AddCategoriesToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :categories, :text
  end
end

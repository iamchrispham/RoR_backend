class AddCountryToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :country_code, :string
  end
end

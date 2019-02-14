class AddCountryCodeToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :country_code, :string
  end
end

class AddColumnsToIdentifications < ActiveRecord::Migration
  def change
    add_column :identifications, :identification_number, :string
    add_index :identifications, :identification_number

    add_column :identifications, :active, :boolean, null: false, default: true
    add_index :identifications, :active

  end
end

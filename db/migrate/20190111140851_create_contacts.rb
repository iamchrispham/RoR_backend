# frozen_string_literal: true

class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :contactable, polymorphic: true
      t.string :details
      t.boolean :active, null: false, default: true

      t.attachment :image

      t.timestamps null: false
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE TYPE contact_category AS ENUM ('phone', 'email', 'url', 'other');
        SQL
      end
      dir.down do
        execute <<-SQL
          DROP TYPE contact_category;
        SQL
      end
    end

    add_column :contacts, :category, :contact_category,
               null: false,
               default: 'other'
    add_index :contacts, %i[contactable_id contactable_type]
    add_index :contacts, %i[id category details], unique: true
  end
end

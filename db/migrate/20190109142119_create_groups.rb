# frozen_string_literal: true

class CreateGroups < ActiveRecord::Migration
  def change
    enable_extension 'citext'

    create_table :groups do |t|
      t.citext :name, null: false, index: { unique: true }
      t.citext :location, index: true
      t.text   :about
      t.boolean :active, null: false, default: true

      t.attachment :image

      t.timestamps null: false
      t.references :user, index: true
      t.references :parent, index: true
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE TYPE group_category AS ENUM ('college', 'normal', 'society', 'meetup');
        SQL
      end
      dir.down do
        execute <<-SQL
          DROP TYPE group_category;
        SQL
      end
    end

    add_column :groups, :category, :group_category,
               null: false,
               default: 'college'

    add_foreign_key :groups, :users,
                    name: 'groups_user_id_fk',
                    on_delete: :cascade
  end
end

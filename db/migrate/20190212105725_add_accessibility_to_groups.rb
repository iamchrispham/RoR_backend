# frozen_string_literal: true

class AddAccessibilityToGroups < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE TYPE group_accessibility AS ENUM ('publicly_accessible', 'privately_accessible');
        SQL
      end
      dir.down do
        execute <<-SQL
          DROP TYPE group_accessibility;
        SQL
      end
    end

    add_column :groups, :accessibility, :group_accessibility,
               null: false,
               default: 'publicly_accessible'
  end
end

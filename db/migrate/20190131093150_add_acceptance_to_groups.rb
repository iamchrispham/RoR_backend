# frozen_string_literal: true

class AddAcceptanceToGroups < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE TYPE group_acceptance_mode AS ENUM ('automatic', 'manual');
        SQL
      end
      dir.down do
        execute <<-SQL
          DROP TYPE group_acceptance_mode;
        SQL
      end
    end

    add_column :groups, :acceptance_mode, :group_acceptance_mode,
               null: false,
               default: 'automatic'

    add_column :groups, :email_domain, :string,
               null: false,
               default: ''
  end
end

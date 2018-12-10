require 'rails/generators/migration'

module Showoff
  module Payments
    class AddQuantitiesAndNotesToReceiptsGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      @migration_count = 0

      def self.next_migration_number(_path)
        @migration_number = (Time.now.utc.strftime('%Y%m%d%H%M%S').to_i + @migration_count).to_s
        @migration_count += 1

        @migration_number
      end

      def create_migrations
        migration_template 'migrations/add_quantities_and_notes_to_receipts.rb.erb', 'db/migrate/add_quantities_and_notes_to_receipts.rb'
      end
    end
  end
end

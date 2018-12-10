require 'rails/generators/migration'

module Showoff
  module Sns
    class AddEndpointOwnerToDevicesGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      @migration_count = 0

      def self.next_migration_number(_path)
        @migration_number = (Time.now.utc.strftime('%Y%m%d%H%M%S').to_i + @migration_count).to_s
        @migration_count += 1

        @migration_number
      end

      def create_migrations
        migration_template 'add_endpoint_owner_to_s_n_s_devices.rb.erb', 'db/migrate/add_endpoint_owner_to_s_n_s_devices.rb'
      end
    end
  end
end

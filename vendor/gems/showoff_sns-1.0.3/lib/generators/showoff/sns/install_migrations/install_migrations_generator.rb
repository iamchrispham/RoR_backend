require 'rails/generators/migration'

module Showoff
  # Module name is Sns rather than SNS, so that the command shows as
  # showoff:sns:install_migrations rather than showoff:s_n_s:install_migrations
  module Sns
    class InstallMigrationsGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      @migration_count = 0

      def self.next_migration_number(_path)
        @migration_number = (Time.now.utc.strftime('%Y%m%d%H%M%S').to_i + @migration_count).to_s
        @migration_count += 1

        @migration_number
      end

      def create_migrations
        migration_template 'create_s_n_s_notifications.rb.erb', 'db/migrate/create_s_n_s_notifications.rb'
        migration_template 'create_s_n_s_notified_objects.rb.erb', 'db/migrate/create_s_n_s_notified_objects.rb'
        migration_template 'add_foreign_keys_to_s_n_s_notified_objects.rb.erb', 'db/migrate/add_foreign_keys_to_s_n_s_notified_objects.rb'
        migration_template 'create_showoff_s_n_s_devices.rb.erb', 'db/migrate/create_showoff_s_n_s_devices.rb'
        migration_template 'add_endpoint_owner_to_s_n_s_device.rb.erb', 'db/migrate/add_endpoint_owner_to_s_n_s_device.rb'
      end
    end
  end
end

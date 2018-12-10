require 'rails/generators/migration'

module Showoff
  module Payments
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      @migration_count = 0

      def self.next_migration_number(_path)
        @migration_number = (Time.now.utc.strftime('%Y%m%d%H%M%S').to_i + @migration_count).to_s
        @migration_count += 1

        @migration_number
      end

      def create_migrations
        migration_template 'migrations/create_showoff_payments_vendor_identities.rb.erb', 'db/migrate/create_showoff_payments_vendor_identities.rb'
        migration_template 'migrations/create_showoff_payments_vendor_identity_meta_datas.rb.erb', 'db/migrate/create_showoff_payments_vendor_identity_meta_datas.rb'

        migration_template 'migrations/create_showoff_payments_customer_identities.rb.erb', 'db/migrate/create_showoff_payments_customer_identities.rb'
        migration_template 'migrations/create_showoff_payments_providers.rb.erb', 'db/migrate/create_showoff_payments_providers.rb'

        migration_template 'migrations/create_showoff_payments_sources.rb.erb', 'db/migrate/create_showoff_payments_sources.rb'

        migration_template 'migrations/create_showoff_payments_receipts.rb.erb', 'db/migrate/create_showoff_payments_receipts.rb'
        migration_template 'migrations/create_showoff_payments_refunds.rb.erb', 'db/migrate/create_showoff_payments_refunds.rb'
        migration_template 'migrations/create_showoff_payments_receipts_vouchers.rb.erb', 'db/migrate/create_showoff_payments_receipts_vouchers.rb'
      end

      def copy_locale
        copy_file 'locales/en.yml', 'config/locales/showoff_payments.en.yml'
      end
    end
  end
end

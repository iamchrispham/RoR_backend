require 'rails/generators/active_record'
require 'generators/migration_helper'

module ActiveRecord
  module Showoff
    module Sns
      # Based on devise active_record generator
      class NotifierGenerator < ActiveRecord::Generators::Base
        include ::Generators::MigrationHelper

        argument :attributes, type: :array, default: [], banner: 'field:type field:type'
        source_root File.expand_path('../templates', __FILE__)

        def copy_showoff_sns_migration
          migration_template 'migration.rb.erb', "db/migrate/showoff_sns_create_notifier_#{table_name}.rb", migration_version: migration_version
        end

        def copy_notifer_class
          template 'notifier.rb.erb', "app/notifiers/#{table_name.singularize}.rb"
        end
      end
    end
  end
end

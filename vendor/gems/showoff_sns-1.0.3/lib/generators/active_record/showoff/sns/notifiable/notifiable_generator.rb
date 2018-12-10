require 'rails/generators/active_record'
require 'generators/migration_helper'

module ActiveRecord
  module Showoff
    module Sns
      class NotifiableGenerator < ActiveRecord::Generators::Base
        include ::Generators::MigrationHelper

        argument :attributes, type: :array, default: [], banner: 'field:type field:type'
        source_root File.expand_path('../templates', __FILE__)

        def copy_showoff_sns_notifiable_migration
          if (behavior == :invoke && model_exists?) || (behavior == :revoke && migration_exists?(table_name, 'notifiable'))
            migration_template 'migration_existing.rb.erb', "db/migrate/add_showoff_sns_notifiable_to_#{table_name}.rb", migration_version: migration_version
          else
            migration_template 'migration.rb.erb', "db/migrate/showoff_sns_create_notifiable_#{table_name}.rb", migration_version: migration_version
          end
        end

        def generate_model
          invoke 'active_record:model', [name], migration: false unless model_exists? && behavior == :invoke
        end

        def inject_notifiable_concern
          class_path = namespaced? ? class_name.to_s.split('::') : [class_name]
          inject_into_class(model_path, class_path.last, content) if model_exists?
        end

        private

        def content
          <<CLASS_CONTENT
  include Showoff::SNS::Notifiable
CLASS_CONTENT
        end
      end
    end
  end
end

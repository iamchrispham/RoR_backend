require 'rails/generators/active_record'
require 'generators/showoff/path_helper'
require 'generators/showoff/generator_helper'

module Showoff
  module Concerns
    module Slugable
      class ModelGenerator < ActiveRecord::Generators::Base
        include Showoff::Generators::PathHelper
        include Showoff::Generators::GeneratorHelper

        desc 'This generator will create a model (and associated migration) which includes the Slugable concern.'
        argument :attributes, type: :array, default: [], banner: 'field:type field:type'
        source_root File.expand_path('../templates', __FILE__)

        def copy_showoff_concerns_slugable_migration
          if (behavior == :invoke && model_exists?) || (behavior == :revoke && migration_exists?('concerns_slugable', table_name))
            migration_template 'migration_existing.rb.erb', "db/migrate/add_showoff_concerns_slugable_to_#{table_name}.rb", migration_version: migration_version
          else
            migration_template 'migration.rb.erb', "db/migrate/create_showoff_concerns_slugable_#{table_name}.rb", migration_version: migration_version
          end
        end

        def generate_model
          invoke 'active_record:model', [name], migration: false unless model_exists? && behavior == :invoke
        end

        def inject_notifiable_concern
          inject_into_class(model_path, model_class_path.last, content) if model_exists?
        end

        private

        def content
          "#{injection_spaces}include Showoff::Concerns::Slugable\n"
        end
      end
    end
  end
end

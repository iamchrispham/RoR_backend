module Generators
  module MigrationHelper
    # Sourced from the Devise gem.

    private

    def rails5?
      Rails.version.start_with? '5'
    end

    def migration_version
      "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if rails5?
    end

    def model_exists?
      File.exist?(File.join(destination_root, model_path))
    end

    def migration_exists?(table_name, type = 'notifier')
      Dir.glob("#{File.join(destination_root, migration_path)}/[0-9]*_*.rb").grep(/\d+_add_showoff_sns_#{type}_to_#{table_name}.rb$/).first
    end

    def migration_path
      @migration_path ||= File.join('db', 'migrate')
    end

    def model_path
      @model_path ||= File.join('app', 'models', "#{file_path}.rb")
    end
  end
end

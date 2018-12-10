require 'generators/showoff/path_helper'
require 'generators/showoff/generator_helper'

module Showoff
  module Notifiers
    class FacebookFriendNotifiers < Rails::Generators::Base
      include Rails::Generators::Migration
      include Showoff::Generators::PathHelper
      include Showoff::Generators::GeneratorHelper

      desc 'This generator will install the migrations necessary for using the facebook friend notifier'
      source_root File.expand_path('../templates', __FILE__)

      @migration_count = 0

      def self.next_migration_number(_path)
        @migration_number = (Time.now.utc.strftime('%Y%m%d%H%M%S').to_i + @migration_count).to_s
        @migration_count += 1

        @migration_number
      end

      def copy_showoff_facebook_friend_notifiers_migration
        migration_template 'migration.rb.erb', 'db/migrate/create_showoff_facebook_friend_notifiers.rb', migration_version: migration_version
      end
    end
  end
end

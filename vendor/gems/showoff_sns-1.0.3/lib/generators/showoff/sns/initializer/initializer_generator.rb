module Showoff
  # Module name is Sns rather than SNS, so that the command shows as
  # showoff:sns:initializer rather than showoff:s_n_s:initializer
  module Sns
    class InitializerGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      def create_initializer
        template 'initializer.rb.erb', 'config/initializers/showoff_sns.rb'
      end
    end
  end
end

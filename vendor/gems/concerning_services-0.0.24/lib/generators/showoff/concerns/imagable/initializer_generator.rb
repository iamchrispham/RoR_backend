require 'rails/generators/migration'

module Showoff
  module Concerns
    module Imagable
      class InitializerGenerator < Rails::Generators::Base
        desc 'This generator will install a Paperclip initializer file used by the Imagable concern.'
        source_root File.expand_path('../templates', __FILE__)

        def install_paperclip_initializer
          template 'paperclip.rb.erb', 'config/initializers/paperclip.rb'
        end
      end
    end
  end
end

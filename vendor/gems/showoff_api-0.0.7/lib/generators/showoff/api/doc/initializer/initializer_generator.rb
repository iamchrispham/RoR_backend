module Showoff
  module Api
    module Doc
      class InitializerGenerator < Rails::Generators::Base
        source_root File.expand_path('../templates', __FILE__)
        def install_apipie
          invoke 'apipie:install'
        end
      end
    end
  end
end

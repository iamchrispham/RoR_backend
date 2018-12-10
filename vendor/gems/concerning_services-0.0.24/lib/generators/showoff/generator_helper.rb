module Showoff
  module Generators
    module GeneratorHelper
      private

      def injection_spaces
        '  ' * model_class_path.length
      end

      def model_class_path
        namespaced? ? class_name.to_s.split('::') : [class_name]
      end

      def rails5?
        Rails.version.start_with? '5'
      end

      def migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if rails5?
      end
    end
  end
end

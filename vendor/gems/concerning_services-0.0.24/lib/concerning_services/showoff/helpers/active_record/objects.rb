module Showoff
  module Helpers
    module ActiveRecord
      module Objects
        def objects(klass, attribute)
          klass.where(attribute => pluck(:id))
        end
      end
    end
  end
end

module Showoff
  module Payments
    module Services
      module Concerns
        module BaseConcern
          include ::Gem::Deprecate
          include ::Showoff::Payments::Errors
        end
      end
    end
  end
end

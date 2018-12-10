module Showoff
  module Payments
    module Providers
      module Sources
        class Stripe < Base
          # Exposes all attributes of Stripe::Source by default
          def last_four
            last4
          end

          def provider_identifier
            id
          end
        end
      end
    end
  end
end

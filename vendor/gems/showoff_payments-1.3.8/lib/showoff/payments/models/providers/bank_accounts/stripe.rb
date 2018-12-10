module Showoff
  module Payments
    module Providers
      module BankAccounts
        class Stripe < Base

          # Exposes all attributes of Stripe::BankAccount by default
        def last_four
            last4
          end
        end
      end
    end
  end
end

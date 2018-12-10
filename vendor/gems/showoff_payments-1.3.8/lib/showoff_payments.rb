module Showoff
  module Payments
    class Railtie < Rails::Railtie
      railtie_name :showoff_payments

      rake_tasks do
        load 'tasks/showoff_payments_tasks.rake'
      end
    end
  end
end

require 'concerning_services'
require 'showoff_response_codes'
require 'active_model_serializers'
require 'showoff/payments'

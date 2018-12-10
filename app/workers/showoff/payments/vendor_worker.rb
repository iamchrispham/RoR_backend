require 'sidekiq'

module Showoff
  module Payments
    class VendorWorker
      include Sidekiq::Worker
      include Api::ErrorHelper
      sidekiq_options queue: :default, retry: 3

      def perform(vendor_id, vendor_type)
        vendor = vendor_type.constantize.find_by(id: vendor_id)

        if vendor.respond_to? :vendor_data
          vendor_data = vendor.vendor_data
          return if vendor_data[:country].blank?

          data = {}
          if vendor_data[:legal_entity]
            data[:legal_entity] = vendor_data[:legal_entity]
          end

          if vendor.identification.present?
            identification = {
              url: vendor.identification.front_url,
              number: vendor.identification.identification_number,
            }

            data[:identification] = identification
          end

          payment_service = Showoff::Payments::Services::PaymentService.new(vendor: vendor)
          payment_service.verify_vendor_identity(data)
        end
      end
    end
  end
end

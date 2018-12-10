module Api
  module V1
    module Users
      class AddressesController < ApiController

        before_action :set_address, only: [:update, :destroy, :update]

        def index
          addresses = current_api_user.addresses.active.limit(limit).offset(offset)
          success_response(addresses: serialized_resource(addresses, ::Addresses::OverviewSerializer))
        end

        def create
          address = current_api_user.addresses.new(address_params)
          if address.save
            success_response(address: serialized_resource(address, ::Addresses::OverviewSerializer))
          else
            active_record_error_response(address)
          end
        end

        def update
          if @address.update_attributes(address_params)
            success_response(address: serialized_resource(@address, ::Addresses::OverviewSerializer))
          else
            active_record_error_response(@address)
          end
        end

        def show
          success_response(address: serialized_resource(@address, ::Addresses::OverviewSerializer))
        end

        def destroy
          if @address.destroy
            addresses = current_api_user.addresses.active
            success_response(addresses: serialized_resource(addresses, ::Addresses::OverviewSerializer))
          else
            active_record_error_response(@address)
          end
        end


        private
        def address_params
          params.require(:address).permit!
        end

        def set_address
          @address = Address.find_by(id: params[:address_id] || params[:id])
          @address_id = @address.id

          if @address.blank?
            error_response((t 'api.responses.users.addresses.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
          end
        end


      end
    end
  end
end

module Api
  module V1
    module Users
      class DevicesController < ApiController
        def create
          device = Showoff::SNS::Device.find_by(uuid: device_params[:uuid])
          device ||= Showoff::SNS::Device.find_by(push_token: device_params[:push_token])

          if device.nil?
            device = current_api_user.devices.create(device_params)
          else
            device.update(device_params)
            device.update_attributes(active: true, owner: current_api_user)
          end

          success_response(device: serialized_resource(device, Showoff::SNS::Device::Serializer))
        rescue StandardError => e
          error_response(I18n.t('api.responses.devices.cannot_save', error: e), Showoff::ResponseCodes::INTERNAL_ERROR)
          logger.warn "Error, cannot save user device: #{e}"
        end

        def destroy
          device = current_api_user.devices.find_by(uuid: params[:uuid])

          if device
            device.update_attributes(active: false)
            success_response(device: serialized_resource(device, Showoff::SNS::Device::Serializer))
          else
            error_response(I18n.t('api.responses.devices.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
          end
        rescue StandardError => e
          error_response(I18n.t('api.responses.devices.cannot_delete', error: e), Showoff::ResponseCodes::INTERNAL_ERROR)
          logger.warn "Error, cannot save user device: #{e}"
        end

        private

        def device_params
          params.require(:device).permit!
        end
      end
    end
  end
end

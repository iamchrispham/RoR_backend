module Api
  module V1
    module Users
      class IdentificationsController < ApiController

        def create
          identification = current_api_user.identifications.new(identification_params.except(:front_image_url, :back_image_url))
          if identification.valid?
            identification.save

            image_service = Showoff::Services::ImageService.new(klass: Identification.to_s, id: identification.id, attribute: :front_image)
            image_service.import_from_url(identification_params[:front_image_url])

            image_service = Showoff::Services::ImageService.new(klass: Identification.to_s, id: identification.id, attribute: :back_image)
            image_service.import_from_url(identification_params[:back_image_url])

            current_api_user.update_on_mailing_list

            success_response(user: current_api_user.cached(current_api_user, type: :private))
          else
            active_record_error_response(identification)
          end
        rescue StandardError => e
          report_error(e)
          identification.destroy! unless identification.blank?
          error_response(I18n.t('api.responses.identifications.cannot_save'), Showoff::ResponseCodes::INTERNAL_ERROR)
        end

        def destroy
          if current_api_user.identifications.update_all(verified: false, pending_verification: false)
            success_response(user: current_api_user.cached(current_api_user, type: :private))
          end
        rescue StandardError => e
          report_error(e)
          error_response(I18n.t('api.responses.identifications.cannot_delete'), Showoff::ResponseCodes::INTERNAL_ERROR)
        end

        private

        def identification_params
          params.require(:identification).permit(:identification_type_id, :front_image_url, :back_image_url, :user_id, :identification_number)
        end
      end
    end
  end
end

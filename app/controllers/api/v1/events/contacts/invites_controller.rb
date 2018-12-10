module Api
  module V1
    module Events
      module Contacts
        class InvitesController < EventsBaseController
          def create
            contact = params[:contact]
            event = Event.find_by(id: params[:event_id])

            name = contact_service.invite(contact, current_api_user, event, (params[:invitation_user_id] || params[:user_id]))

            if contact_service.errors.nil?
              success_response(
                sent: true,
                message: I18n.t('api.responses.users.contacts.invite.sent', user: name)
              )
            else
              error = contact_service.errors.first
              error_response(error[:message], error[:type])
            end
          end

          private

          def contact_service
            @contact_services ||= Showoff::Services::ContactService.new(params)
          end
        end
      end
    end
  end
end

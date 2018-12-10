module Api
  module V1
    module Events
      module Tickets
        class TicketsController < EventsBaseController

          skip_before_filter :doorkeeper_authorize!
          before_filter :set_user

          def view
            if @event && @event.event_ticket_detail
              @event.event_ticket_detail.record_view!(@user)
              redirect_to @event.event_ticket_detail.url
            else
              error_response(I18n.t('api.responses.events.cancelled'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
            end
          end

          def set_user
            token = params[:token]
            access_token = Doorkeeper::AccessToken.find_by(token: token)
            if token.blank? || access_token.blank?
              error_response(I18n.t('api.responses.events.cancelled'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
              return
            end

            @user = User.find_by(id: access_token.resource_owner_id)
            if @user.blank?
              error_response(I18n.t('api.responses.events.cancelled'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
              return
            end
          end

        end
      end
    end
  end
end

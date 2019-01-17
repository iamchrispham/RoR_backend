# frozen_string_literal: true

module Api
  module V1
    module Events
      class RequestsController < EventsBaseController
        before_filter :set_attendee, :set_attendee_request, only: [:accept, :reject]


        def accept
          @request.accept!
          success_response(request: serialized_resource(@request, ::Events::Attendees::Requests::OverviewSerializer))
        end

        def reject
          @request.reject!

          success_response(request: serialized_resource(@request, ::Events::Attendees::Requests::OverviewSerializer))
        end

        private

        def set_attendee
          @attendee = EventAttendee.find_by(id: params[:attendee_id] || params[:id])

          if @attendee.blank?
            error_response(I18n.t('api.responses.events.attendees.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
            return
          end

          if @attendee.event.user_from_event_owner != current_api_user
            error_response(I18n.t('api.responses.invalid_action'), Showoff::ResponseCodes::INVALID_ARGUMENT)
            return
          end
        end

        def set_attendee_request
          @request = @attendee.event_attendee_request
        end
      end
    end
  end
end

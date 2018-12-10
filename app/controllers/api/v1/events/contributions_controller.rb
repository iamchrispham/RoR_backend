module Api
  module V1
    module Events
      class ContributionsController < EventsBaseController
        before_filter :set_attendee, only: [:create, :price]

        def create
          contribution = event_contribution_service.create(@attendee, contribution_params)
          if event_contribution_service.errors.nil?
            success_response(
              contribution: serialized_resource(
                contribution, ::Events::Contributions::OverviewSerializer, user: current_api_user
              )
            )
          else
            error = event_contribution_service.errors.first
            error_response(error[:message], error[:type])
          end
        end

        def price
          price = event_contribution_service.price(@attendee, contribution_params)
          if event_contribution_service.errors.nil?
            success_response(
              price: price
            )
          else
            error = event_contribution_service.errors.first
            error_response(error[:message], error[:type])
          end
        end

        private

        def set_attendee
          @attendee = EventAttendee.find_by(id: params[:attendee_id] || params[:id])

          if @attendee.blank?
            error_response(I18n.t('api.responses.events.attendees.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
            return
          end
        end

        def contribution_params
          params.require(:contribution).permit!
        end

        def event_contribution_service
          @event_contribution_service ||= EventContributionService.new
        end
      end
    end
  end
end

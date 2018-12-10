module Api::V1
  module Events
    class EventsBaseController < ApiController
      before_action :set_event

      private

      def set_event
        @event = Event.active.find_by(id: params[:event_id] || params[:id])

        if @event.blank?
          error_response(I18n.t('api.responses.events.cancelled'),Showoff::ResponseCodes::OBJECT_NOT_FOUND)
          return
        end
      end

      def events_service
        @events_service ||= EventService.new
      end

      def event_params
        params.require(:event).permit!
      end
    end
  end
end

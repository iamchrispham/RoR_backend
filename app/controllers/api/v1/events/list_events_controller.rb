module Api
  module V1
    module Events
      class ListEventsController < EventsBaseController
        skip_before_action :set_event, only: :index

        def index          
          if params[:owner_id].present? && params[:owner_type].present?
            event_owner = params[:owner_type].classify.constantize.find_by(id: params[:owner_id])

            return error_response((t 'api.responses.events.no_event_owner_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND) unless event_owner           
            events_collection = case params[:owner_type]
            when 'User'
              event_owner.events.not_private.active
            when 'Company'
              event_owner.events.where.not(event_ownerable_type: 'Company').or(Event.where(event_ownerable_type: 'Company').approved).not_private.active
            when 'Group'
              event_owner.events.not_private.active
            end
            success_response(events: events_collection.includes([:event_media_items]).map { |event| event.cached(current_api_user, type: :feed) })
          else
            error_response((t 'api.responses.events.no_event_owner_provided'), Showoff::ResponseCodes::MISSING_ARGUMENT)
          end
        end
      end
    end
  end
end
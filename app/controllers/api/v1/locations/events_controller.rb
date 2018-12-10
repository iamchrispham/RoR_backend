module Api
  module V1
    module Locations
      class EventsController < ApiController

        def create
          success_response(events: events.map { |event| event.cached(current_api_user, type: :feed) })
        end

        private
        def events
          objects_for_filters(Event.active, params, nil, limit, offset, current_api_user)
        end
      end
    end
  end
end

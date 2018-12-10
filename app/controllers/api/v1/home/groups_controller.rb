module Api
  module V1
    module Home
      class GroupsController < ApiController

        def create
          success_response(events: events.map { |event| event.cached(current_api_user, type: :feed) })
        end

        private
        def events
          objects_for_filters(Event.with_group.active.starting_at_or_after(Time.now.beginning_of_day), params, nil, limit, offset, current_api_user)
        end

      end
    end
  end
end

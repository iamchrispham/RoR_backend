module Api
  module V1
    module Tags
      class EventsController < ApiController

        def index
          tag = Tag.sanitize_tag(params[:tag_id])

          events = Event.active.joins(:tags).where(tags: { text: tag }).limit(limit).offset(offset)
          events = events.not_eighteen_plus unless current_api_user.eighteen_plus
          attending_events = current_api_user.possible_attending_events.uniq!
          events = events.where(private_event: false).or(events.where(id: attending_events))

          success_response(events: events.uniq!.map { |event| event.cached(current_api_user, type: :feed) })
        end
      end
    end
  end
end

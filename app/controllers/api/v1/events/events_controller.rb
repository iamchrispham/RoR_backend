module Api
  module V1
    module Events
      class EventsController < EventsBaseController
        skip_before_action :set_event, only: [:index, :create]

        def index
          success_response(
            count: current_api_user.events.active.count,
            events: current_api_user.events.includes([:event_media_items]).active.limit(limit).offset(offset).order(created_at: :desc).map { |event| event.cached(current_api_user, type: :feed) }
          )
        end

        def show
          success_response(events: @event.cached(current_api_user, type: :overview))
        end

        def create
          event = events_service.create(event_params, current_api_user)
          if events_service.errors.nil?
            success_response(event: event.cached(current_api_user, type: :overview))
          else
            error = events_service.errors.first
            error_response(error[:message], error[:type])
          end
        end

        def update
          if @event.date_time < Time.now
            error_response(I18n.t('api.responses.events.attendees.event_past'), Showoff::ResponseCodes::INVALID_ARGUMENT)
            return
          end
          ensure_current_api_user_owns(@event) do
            event = events_service.update(@event, event_params)
            if events_service.errors.nil?
              success_response(event: event.cached(current_api_user, type: :overview))
            else
              error = events_service.errors.first
              error_response(error[:message], error[:type])
            end
          end
        end

        def destroy
          if @event
            ensure_current_api_user_owns(@event) do
              if @event.deactivate_conversation! && @event.deactivate!
                success_response(destroyed: true)
              else
                active_record_error_response(@event)
              end
            end
          else
            error_response((t 'api.responses.events.cancelled'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
          end
        end
      end
    end
  end
end

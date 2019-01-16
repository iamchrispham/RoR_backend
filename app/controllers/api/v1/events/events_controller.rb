module Api
  module V1
    module Events
      class EventsController < EventsBaseController
        skip_before_action :set_event, only: [:index, :create]
        before_action :set_event_owner, only: %i[create edit update destroy]

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
          event = events_service.create(event_params, current_api_user, @event_owner)
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

        def set_event_owner
          if params[:event_owner] && params[:event_owner][:owner_type] && params[:event_owner][:owner_id]
            @event_owner = params[:event_owner][:owner_type].classify.constantize.find_by(id: params[:event_owner][:owner_id])
            error_response((t 'api.responses.events.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND) unless @event_owner

            action_authorised = case @event_owner
            when User
              %w[edit update destroy].include?(params[:action]) ? current_api_user == @event_owner : true
            when Company#, Group
              current_api_user.send(@event_owner.class.to_s.pluralize.downcase).include?(@event_owner)
            else
              false
            end

            error_response((t 'api.responses.events.invalid_event_owner'), Showoff::ResponseCodes::INVALID_ARGUMENT) unless action_authorised
          else
            error_response((t 'api.responses.events.no_event_owner'), Showoff::ResponseCodes::MISSING_ARGUMENT)
          end
        end
      end
    end
  end
end

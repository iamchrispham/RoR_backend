module Api::V1
  module Users
    class EventsController < ApiController
      before_action :set_pagination, only: [:index]
      before_action :set_scope, only: [:index]

      def index
        if user
          success_response(
            meta: {
              count: count,
              mutual_user_count: mutual_count,
              mutual_users: mutual_users.map { |mutual_user| mutual_user.cached(user, type: :feed) }
            },
            events: events.limit(limit).offset(offset).map { |event| event.cached(current_api_user, type: :feed) }
          )
        else
          error_response((t 'api.responses.users.not_found'), Showoff::ResponseCodes::INVALID_ARGUMENT)
        end
      end

      private

      def count
        events.count
      end

      def mutual_count
        current_api_user.mutual_friends_for_events(events).count
      end

      def mutual_users
        current_api_user.mutual_friends_for_events(events).limit(2)
      end

      def events
        case @scope
        when :hosting
          events = user.hosting_events.active
        when :attending
          events = user.potentially_attending_events.where.not(user: user).active
        end

        if user != current_api_user
          events = events.not_eighteen_plus unless current_api_user.eighteen_plus
          attending_events = current_api_user.potentially_attending_events
          events = events.where(private_event: false).or(events.where(id: attending_events))
        end

        events = current_api_user.mutual_events(events) if params[:mutual]

        events.order_to_now
      end

      def user
        user_service.user_by_identifier(params[:user_id])
      end

      def set_scope
        @scope = params[:scope] || :hosting
        @scope = @scope.to_sym
      end
    end
  end
end

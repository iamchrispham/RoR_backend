module Api
  module V1
    module Events
      module Friends
        class UninvitedController < ApiController
          before_filter :set_event

          def index
            if @event
              friends = current_api_user.friends.where.not(id: current_api_user.friends.joins(:event_attendees).where(event_attendees: { event_id: @event.id }))
                                        .for_term(params[:term]).ordered_by_name
              friends = friends.where.not(id: event.user.id) if params[:forward].present?
              friends = friends.limit(params[:limit]).offset(params[:offset])

              success_response(friends: friends.limit(limit).offset(offset).map { |user| user.cached(current_api_user, type: :public, event: @event) })
            else
              error_response(I18n.t('api.responses.events.cancelled'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
            end
          end

          private

          def set_event
            @event = current_api_user.hosting_events.find(params[:event_id] || params[:id])
          end
        end
      end
    end
  end
end

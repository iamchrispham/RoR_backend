module Api
  module V1
    module Users
      class FriendsController < ApiController
        before_action :set_scope, only: [:index]
        before_action :set_friend, only: [:destroy]

        # Scoped to user who current api user wants to see the friends for
        def index
          user = user_service.user_by_identifier(params[:user_id])
          event = nil

          if user
            case @scope
            when :all
              friends = user.friends
            when :mutual
              friends = user.mutual_friends(current_api_user)
            end

            friends = friends.for_term(params[:term]) if params[:term]

            if params[:event_id].present? && params[:forward].present?
              event = Event.active.find(params[:event_id])

              if event
                friends = friends.where.not(id: event.user_from_event_owner.id)
                friends = friends.where.not(id: event.attending_users)
              end
            end
            success_response(friends: friends.ordered_by_friendships.limit(limit).offset(offset).map {|user| user.cached(current_api_user, type: :public, event: event)})
          else
            error_response(I18n.t('api.responses.users.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
          end
        end

        # Scoped to current api user removing a friend of their own.
        def destroy
          if current_api_user.remove_friend(@friend)
            success_response(destroyed: true)
          else
            active_record_error_response(@friend_request)
          end
        end

        private

        def set_scope
          @scope = params[:scope] || :all
          @scope = @scope.to_sym

          unless valid_scopes.include? @scope
            error_response(I18n.t('api.responses.friends.invalid_scope'), Showoff::ResponseCodes::INVALID_ARGUMENT)
          end
        end

        def valid_scopes
          %i[all mutual]
        end

        def set_friend
          user = user_service.user_by_identifier(params[:user_id])
          if user
            @friend = current_api_user.friends.find_by(id: user.id)
            if @friend.blank?
              error_response(I18n.t('api.responses.friends.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
            end
          else
            error_response(I18n.t('api.responses.users.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
          end
        end
      end
    end
  end
end

module Api
  module V1
    module Users
      class FriendRequestsController < ApiController
        before_action :set_scope, only: [:index]
        before_action :set_pending_friend_request, only: [:accept, :reject]
        before_action :set_sent_friend_request, only: [:cancel]

        # Scope to Current API User's friend requests
        def index
          case @scope
          when :pending
            requests = current_api_user.pending_friend_requests
          when :sent
            requests = current_api_user.friend_requests
          end

          success_response(requests: serialized_resource(requests.limit(limit).offset(offset), ::Friends::Requests::OverviewSerializer, user: current_api_user))
        end

        # Scoped to User who they want to add a friend
        def create
          friend = user_service.user_by_identifier(params[:user_id])
          if friend
            friend_request = current_api_user.friend_requests.new(friend: friend)
            if friend_request.save
              friend_request.accept if friend.business?
              success_response(request: serialized_resource(friend_request, ::Friends::Requests::OverviewSerializer, user: current_api_user))
            else
              active_record_error_response(friend_request)
            end
          else
            error_response(I18n.t('api.responses.users.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
          end
        end

        # Scoped to current api user's pending friend requests
        def accept
          if @friend_request.accept
            success_response(accepted: true)
          else
            active_record_error_response(@friend_request)
          end
        end

        # Scoped to current api user's pending friend requests
        def reject
          if @friend_request.destroy
            success_response(rejected: true)
          else
            active_record_error_response(@friend_request)
          end
        end

        # Scoped to current api user's sent friend requests
        def cancel
          if @friend_request.destroy
            success_response(cancelled: true)
          else
            active_record_error_response(@friend_request)
          end
        end

        private

        def set_scope
          @scope = params[:scope] || :pending
          @scope = @scope.to_sym
          unless valid_scopes.include?(@scope)
            error_response(I18n.t('api.responses.friends.requests.invalid_scope'), Showoff::ResponseCodes::INVALID_ARGUMENT)
          end
        end

        def valid_scopes
          [:pending, :sent]
        end

        def set_pending_friend_request
          @friend_request = set_friend_request(:pending_friend_requests)
        end

        def set_sent_friend_request
          @friend_request = set_friend_request(:friend_requests)
        end

        def set_friend_request(scope)
          unless current_api_user.respond_to?(scope)
            error_response(I18n.t('api.responses.friends.requests.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
          else
            @friend_request = current_api_user.send(scope).find_by(id: params[:friend_request_id])
            if @friend_request.blank?
              error_response(I18n.t('api.responses.friends.requests.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
            end
            @friend_request
          end
        end
      end
    end
  end
end

module Api
  module V1
    module Chats
      class RoomsController < ApiController
        def create
          room = ChatkitService.new(current_api_user, recipient_ids: chat_params[:recipient_ids]).create_room
          success_response(room_id: room[:body][:id])
        end

        private

        def chat_params
          params.require(:chat).permit(recipient_ids: [])
        end
      end
    end
  end
end

module Api
  module V1
    module Events
      module Timelines
        class LikesController < TimelinesBaseController

          def create
            like = @timeline_item.event_timeline_item_likes.build(user: current_api_user)
            if like.save
              success_response(like: serialized_resource(like, ::Events::Timelines::Items::Likes::OverviewSerializer))
            else
              active_record_error_response(like)
            end
          end

          def destroy
            like = current_api_user.event_timeline_item_likes.find_by(event_timeline_item: @timeline_item)
            if like
              like.destroy
              success_response(destroyed: true)
            else
              error_response((t 'api.responses.events.timelines.item.likes.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
            end
          end

          private

          def set_podcast
            @podcast = Podcast.find_by(id: params[:podcast_id])
          end
        end
      end

    end
  end
end

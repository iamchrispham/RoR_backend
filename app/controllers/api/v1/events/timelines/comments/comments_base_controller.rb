module Api
  module V1
    module Events
      module Timelines
        module Comments
          class CommentsBaseController < TimelinesBaseController

            before_action :set_comment

            private
            def set_comment
              @comment = EventTimelineItemComment.active.find_by(id: params[:comment_id] || params[:id])

              if @comment.blank?
                error_response(I18n.t('api.responses.events.timelines.item.comments.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
                return
              end
            end

            def comment_params
              params.require(:comment).permit!
            end

          end
        end
      end
    end
  end
end

module Api
  module V1
    module Events
      module Timelines
        module Comments
          class CommentsController < CommentsBaseController

            skip_before_action :set_comment, only: [:index, :create]

            def index
              ensure_event_timeline_item_is_active(@timeline_item) do
                comments = @timeline_item.event_timeline_item_comments.active.includes(:user).order(created_at: :desc).limit(params[:limit]).offset(params[:offset])
                success_response(comments: serialized_resource(comments, serializer, user: current_api_user))
              end
            end

            def show
              ensure_comment_is_active(@comment) do
                success_response(comment: serialized_resource(@comment, serializer, user: current_api_user))
              end
            end

            def create
              comment = @timeline_item.event_timeline_item_comments.build(user: current_api_user, content: comment_params[:content])
              if comment.save
                success_response(comment: serialized_resource(comment, serializer, user: current_api_user))
              else
                active_record_error_response(comment)
              end
            end

            def update
              ensure_current_api_user_owns(@comment) do
                if @comment.update_attributes(content: comment_params[:content])
                  success_response(comment: serialized_resource(@comment, serializer, user: current_api_user))
                else
                  active_record_error_response(@comment)
                end
              end
            end

            def destroy
              ensure_current_api_user_owns(@comment) do
                if @comment.destroy
                  success_response(destroyed: true)
                else
                  active_record_error_response(@comment)
                end
              end
            end

            private

            def serializer
              ::Events::Timelines::Items::Comments::OverviewSerializer
            end

          end
        end
      end
    end
  end
end

module Api
  module CommentHelper
    def ensure_comment_is_active(comment)
      ensure_user_is_active(comment.user) do
        ensure_event_timeline_item_is_active(comment.event_timeline_item) do
          yield
        end
      end
    end
  end
end

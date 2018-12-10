module Application
  module Reports
    class CommentsController < WebController
      before_filter :set_comment, except: [:index]

      def index
        @reported_comments = EventTimelineItemComment.pending_reports.order(inactive_at: :desc).paginate(page: params[:page]).uniq
      end

      def suspend_user
        @comment.user.update_attributes(suspended: true, suspended_at: Time.now)
        reports_considered!

        flash[:notice] = t 'views.users.user_suspended'
        redirect_to reports_comments_path
      end

      def activate_comment
        @comment.update_attributes(active: true)
        reports_considered!

        flash[:notice] = t 'views.events.timeline_items.comments.activated'
        redirect_to reports_comments_path
      end

      private

      def reports_considered!
        @comment.reports.update_all(considered: true)
      end

      def set_comment
        @comment = EventTimelineItemComment.find_by(id: params[:comment_id])
      end
    end
  end
end

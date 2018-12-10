module Application
  module Reports
    class TimelineItemsController < WebController
      before_filter :set_timeline_item, except: [:index]

      def index
        @reported_timeline_items = EventTimelineItem.pending_reports.order(inactive_at: :desc).paginate(page: params[:page]).uniq
      end

      def suspend_user
        @timeline_item.user.update_attributes(suspended: true, suspended_at: Time.now)
        reports_considered!

        flash[:notice] = t 'views.users.user_suspended'

        redirect_to reports_timeline_items_path
      end

      def activate_timeline_item
        @timeline_item.activate!
        reports_considered!

        flash[:notice] = t 'views.events.activated'
        redirect_to reports_timeline_items_path
      end

      private

      def reports_considered!
        @timeline_item.reports.update_all(considered: true)
      end

      def set_timeline_item
        @timeline_item = EventTimelineItem.find_by(id: params[:timeline_item_id])
      end
    end
  end
end

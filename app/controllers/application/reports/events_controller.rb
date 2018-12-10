module Application
  module Reports
    class EventsController < WebController
      before_filter :set_event, except: [:index]

      def index
        @objects = Event.pending_reports.order(inactive_at: :desc).paginate(page: params[:page]).uniq
      end

      def activate_event
        @event.activate!
        reports_considered!

        flash[:notice] = t 'views.events.activated'
        redirect_to reports_events_path
      end

      def deactivate_event
        @event.deactivate!
        reports_considered!
        flash[:notice] = t 'views.events.deactivated'
        redirect_to reports_events_path
      end

      private

      def reports_considered!
        @event.reports.update_all(considered: true)
      end

      def set_event
        @event = Event.find_by(id: params[:event_id])
      end
    end
  end
end

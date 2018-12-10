module Application
  module Tickets
    class TicketsController < WebController
      before_filter :authenticate_admin!
      before_filter :set_filter_start_and_end, only: :index

      authorize_resource 'Event'

      def index
        (@filterrific = initialize_filterrific(
          EventTicketDetail,
          params[:filterrific],
          select_options: {
            sorted_by: EventTicketDetail.options_for_sorted_by,
            by_status: EventTicketDetail.options_for_status
          }
        )) || return

        @objects = @filterrific.find.where(id: current_admin.tickets.active.pluck(:id)).where('event_ticket_details.updated_at >= ? AND event_ticket_details.updated_at <= ?', @start_at, @end_at).paginate(page: params[:page])
        @detail_views = EventTicketDetailView.active.where(event_ticket_detail_id: @objects)
        @users = User.where(id: @detail_views.pluck(:user_id))
      end
    end
  end
end

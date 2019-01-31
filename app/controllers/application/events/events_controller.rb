module Application
  module Events
    class EventsController < WebController
      before_filter :authenticate_admin!
      before_filter :set_event, :set_show_scope, except: [:index]
      before_filter :set_filter_start_and_end, only: :index

      authorize_resource

      def index
        (@filterrific = initialize_filterrific(
            Event,
            params[:filterrific],
            select_options: {
                sorted_by: Event.options_for_sorted_by,
                by_type: Event.options_for_type,
                by_status: Event.options_for_status,
                by_age: Event.options_for_age,
                by_visibility: Event.options_for_visibility,
                by_chat: Event.options_for_chat,
                by_timeline: Event.options_for_timeline,
                by_forwarding: Event.options_for_forwarding,
                by_tickets: Event.options_for_tickets,
                by_contributions: Event.options_for_contributions
            }
        )) || return
        @objects = @filterrific.find.where(id: current_admin.events.pluck(:id)).where('events.date >= ? AND events.date <= ?', @start_at, @end_at).paginate(page: params[:page])
      end

      def show
        @reports = @event.reports.order(updated_at: :desc).paginate(page: params[:report_page])
        @invited_users = @event.invited_users.paginate(page: params[:invited_users_page])
        @attending_users = @event.attending_users.paginate(page: params[:attending_users_page])
        @maybe_attending_users = @event.maybe_attending_users.paginate(page: params[:maybe_attending_users_page])
        @not_attending_users = @event.not_attending_users.paginate(page: params[:not_attending_users_page])

        @event_ticket_detail_views = @event.event_ticket_detail_views.paginate(page: params[:event_ticket_detail_views_page])
        @event_attendee_contributions = @event.event_attendee_contributions.paginate(page: params[:event_attendee_contributions_page])
        @event_shares = @event.event_shares.paginate(page: params[:event_shares_page])
      end

      def deactivate
        if @event.deactivate!
          redirect_to event_path(@event), notice: t('views.events.deactivated')
        else
          redirect_with_error(event_path(@event), t('views.events.error_deactivate'))
        end
      end

      def activate
        if @event.activate!
          redirect_to event_path(@event), notice: t('views.events.activated')
        else
          redirect_with_error(event_path(@event), t('views.events.error_activate'))
        end
      end

      def change_review_status
        if Event.review_statuses.include?(params[:review_status])
          @event.send(params[:review_status] + '!')
          redirect_to event_path(@event), notice: t('views.events.review_status_changed')
        else
          redirect_with_error(event_path(@event), t('views.events.review_status_absent'))
        end
      end

      private

      def set_event
        @event = current_admin.events.find(params[:event_id] || params[:id])
      end

      def set_show_scope
        @scope = params[:scope] || :details
      end

    end
  end
end

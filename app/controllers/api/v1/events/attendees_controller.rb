# frozen_string_literal: true

module Api
  module V1
    module Events
      class AttendeesController < EventsBaseController
        before_filter :check_existing_attendee, only: [:create]
        before_filter :set_attendee, only: [:update]

        def index
          attendees = @event.event_attendees
          attendees = attendees.for_term(params[:term]) unless params[:term].blank?

          success_response(
            attendees: serialized_resource(
              attendees.valid.includes([:user]).order_by_status.limit(limit).offset(offset),
              ::Events::Attendees::OverviewSerializer, user: current_api_user
            )
          )
        end

        def create
          if @event.date < Time.now
            error_response(I18n.t('api.responses.events.attendees.event_past'), Showoff::ResponseCodes::INVALID_ARGUMENT)
            return
          end
          @attendee = @event.event_attendees.new(attendee_params)
          @attendee.user = current_api_user
          if @event.maximum_attendees.present? && @event.attending_users.count >= @event.maximum_attendees && @event.maximum_attendees.positive?
            error_response(I18n.t('api.responses.events.attendees.maximum_attendees'), Showoff::ResponseCodes::INVALID_ARGUMENT)
          elsif @attendee.valid?
            @attendee.save!
            success_response(
              attendee: serialized_resource(
                @attendee,
                ::Events::Attendees::OverviewSerializer, user: current_api_user
              )
            )
          else
            active_record_error_response(@attendee)
          end
        end

        def update
          ensure_current_api_user_owns(@attendee) do
            update_attendee
          end
        end

        private

        # def ensure_owner #TODO Not used but should be
        #   if @event.user == current_api_user
        #     error_response(I18n.t('api.responses.events.attendees.owner_error'), Showoff::ResponseCodes::INVALID_ARGUMENT)
        #   end
        # end

        def check_existing_attendee
          @attendee = @event.event_attendees.find_by(user: current_api_user)

          update_attendee if @attendee.present?
        end

        def set_attendee
          @attendee = EventAttendee.find_by(id: params[:attendee_id] || params[:id])

          if @attendee.blank?
            error_response(I18n.t('api.responses.events.attendees.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
            return
          end
        end

        def attendee_params
          params.require(:attendee).permit!
        end

        def update_attendee
          if @event.date_time < Time.now
            error_response(I18n.t('api.responses.events.attendees.event_past'), Showoff::ResponseCodes::INVALID_ARGUMENT)
            return
          end

          if @event.maximum_attendees.present? && @event.attending_users.where.not(event_attendees: {user: @event.user_from_event_owner}).count >= @event.maximum_attendees && @event.maximum_attendees.positive?
            error_response(I18n.t('api.responses.events.attendees.maximum_attendees'), Showoff::ResponseCodes::INVALID_ARGUMENT)

          elsif @event.attendance_acceptance_required && @attendee.event_attendee_request.present? && @attendee.event_attendee_request.pending?
            @attendee.pending!
            error_response(I18n.t('api.responses.events.attendees.requests.pending'), Showoff::ResponseCodes::INVALID_ARGUMENT)

          elsif @event.attendance_acceptance_required && @attendee.event_attendee_request.present? && @attendee.event_attendee_request.rejected?
            @attendee.pending!
            error_response(I18n.t('api.responses.events.attendees.requests.rejected'), Showoff::ResponseCodes::INVALID_ARGUMENT)

          elsif @attendee.update_attributes(attendee_params)
            success_response(
              attendee: serialized_resource(
                @attendee,
                ::Events::Attendees::OverviewSerializer, user: current_api_user
              )
            )
          else
            active_record_error_response(@attendee)
          end
        end
      end
    end
  end
end

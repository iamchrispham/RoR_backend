# frozen_string_literal: true

module Api
  module V1
    module Groups
      class SubgroupsEventsController < ApiController
        before_action :check_group_presence
        before_action :check_group_ownership, only: %i[approved pending]

        def approved
          events =
            group.subgroups_events_approved
                 .order(id: :desc).limit(limit).offset(offset)
          success_response(
            count: events.count,
            events: serialized_resource(events, ::Events::OverviewSerializer)
          )
        end

        def pending
          events =
            group.subgroups_events_pending
                 .order(id: :desc).limit(limit).offset(offset)
          success_response(
            count: events.count,
            events: serialized_resource(events, ::Events::OverviewSerializer)
          )
        end

        private

        def check_group_presence
          group_not_found_error if group.blank?
        end

        def check_group_ownership
          group_not_found_error if group.owner != current_api_user
        end

        def group
          @group ||= Group.active.find_by(id: params[:group_id])
        end

        def group_not_found_error
          @group_not_found_error ||=
            error_response(t('api.responses.groups.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
        end
      end
    end
  end
end

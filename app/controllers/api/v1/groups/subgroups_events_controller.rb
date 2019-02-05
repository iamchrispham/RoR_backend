# frozen_string_literal: true

module Api
  module V1
    module Groups
      class SubgroupsEventsController < ApiController
        before_action :check_group_presence
        before_action :check_group_ownership

        def confirmed
          events =
            group.subgroups_events.active.viewable_in_parent_owner
                 .order(id: :desc).limit(limit).offset(offset)
          success_response(
            count: events.count,
            events: serialized_resource(subgroups, ::Events::OverviewSerializer)
          )
        end

        def undecided
          events =
            group.subgroups_events.active.undecided_if_viewable_in_parent_owner
                 .order(id: :desc).limit(limit).offset(offset)
          success_response(
            count: events.count,
            events: serialized_resource(subgroups, ::Events::OverviewSerializer)
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

def index
  subgroups = parent_group.subgroups.includes(:contacts).active.limit(limit).offset(offset)
  success_response(
    count: subgroups.count,
    subgroups: serialized_resource(subgroups, ::Subgroups::OverviewSerializer)
  )
end

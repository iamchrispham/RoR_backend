# frozen_string_literal: true

module Api
  module V1
    module Groups
      class SubgroupEventApprovalsController < ApiController
        before_action :check_group_presence
        before_action :check_subgroup_presence
        before_action :check_event_presence, only: %i[request_approval status]
        before_action :check_group_ownership, only: %i[approve revoke]
        before_action :check_subgroup_ownership, only: :request_approval
        before_action :check_event_approval_presence, only: %i[approve revoke]

        def approve
          if event_approval.update(active: true)
            success_response(
              approval: serialized_resource(event_approval, ::Groups::SubgroupEventApprovalSerializer)
            )
          else
            active_record_error_response(event_approval)
          end
        end

        def revoke
          if event_approval.update(active: false)
            success_response(
              approval: serialized_resource(event_approval, ::Groups::SubgroupEventApprovalSerializer)
            )
          else
            active_record_error_response(event_approval)
          end
        end

        def request_approval
          approval =
            SubgroupEventsApproval.new(
              event: event,
              group: group,
              subgroup: subgroup,
              user: subgroup.owner
            )
          if approval.save
            success_response(
              approval: serialized_resource(approval, ::Groups::SubgroupEventApprovalSerializer)
            )
          else
            active_record_error_response(approval)
          end
        end

        def status
          approval =
            SubgroupEventsApproval.where(
              event: event,
              group: group,
              subgroup: subgroup
            ).last
          success_response(approval: serialized_resource(approval, ::Groups::SubgroupEventApprovalSerializer))
        end

        private

        def unpproved_event
          @unpproved_event ||= group.subgroups_events_pending.where(id: params[:event_id]).first
        end

        def approved_event
          @approved_event ||= group.subgroups_events_approved.where(id: params[:event_id]).first
        end

        def check_group_presence
          group_not_found_error if group.blank?
        end

        def check_subgroup_presence
          subgroup_not_found_error if subgroup.blank? || subgroup.parent != group
        end

        def check_event_presence
          event_not_found_error if event.blank?
        end

        def check_event_approval_presence
          approval_not_found_error if event_approval.blank?
        end

        def check_group_ownership
          group_not_found_error if group.owner != current_api_user
        end

        def check_subgroup_ownership
          group_not_found_error if subgroup.owner != current_api_user
        end

        def group
          @group ||= Group.active.find_by(id: params[:group_id])
        end

        def subgroup
          @subgroup ||= Group.active.find_by(id: params[:subgroup_id])
        end

        def event
          @event ||= Event.active.find_by(id: params[:event_id])
        end

        def event_approval
          @event_approval ||= SubgroupEventsApproval.where(
            event: event,
            group: group,
            subgroup: subgroup,
            user: subgroup.owner
          ).first
        end

        def group_not_found_error
          @group_not_found_error ||=
            error_response(t('api.responses.groups.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
        end

        def subgroup_not_found_error
          @subgroup_not_found_error ||=
            error_response(t('api.responses.subgroups.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
        end

        def event_not_found_error
          @event_not_found_error ||=
            error_response(t('api.responses.events.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
        end

        def approval_not_found_error
          @approval_not_found_error ||=
            error_response(
              t('api.responses.subgroup_event_approvals.not_found'),
              Showoff::ResponseCodes::OBJECT_NOT_FOUND
            )
        end
      end
    end
  end
end

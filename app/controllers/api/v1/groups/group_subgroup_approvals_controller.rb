# frozen_string_literal: true

module Api
  module V1
    module Groups
      class GroupSubgroupApprovalsController < ApiController
        before_action :check_group_presence
        before_action :check_subgroup_presence
        before_action :check_subgroup_approval_presence, only: %i[approve revoke status]
        before_action :check_group_ownership,            only: %i[approve revoke]
        before_action :check_subgroup_ownership,         only: :request_approval

        def approve
          result = Group.transaction do
            group.subgroups << subgroup && subgroup_approval.update(active: true)
          end

          if result.present?
            success_response(
              approval: serialized_resource(subgroup_approval, ::Groups::GroupSubgroupApprovalSerializer)
            )
          else
            active_record_error_response(subgroup_approval)
          end
        end

        def revoke
          Group.transaction { subgroup.update(parent: nil) && subgroup_approval.delete }

          head :no_content
        end

        def request_approval
          approval =
            GroupSubgroupApproval.new(
              group: group,
              subgroup: subgroup,
              user: subgroup.owner
            )
          if approval.save
            success_response(
              approval: serialized_resource(approval, ::Groups::GroupSubgroupApprovalSerializer)
            )
          else
            active_record_error_response(approval)
          end
        end

        def status
          success_response(
            approval: serialized_resource(subgroup_approval, ::Groups::GroupSubgroupApprovalSerializer)
          )
        end

        private

        def check_group_presence
          group_not_found_error if group.blank?
        end

        def check_subgroup_presence
          subgroup_not_found_error if subgroup.blank?
        end

        def check_subgroup_approval_presence
          approval_not_found_error if subgroup_approval.blank?
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

        def subgroup_approval
          @subgroup_approval ||=
            GroupSubgroupApproval.find_by(
              group: group,
              subgroup: subgroup,
              user: subgroup.owner
            )
        end

        def group_not_found_error
          @group_not_found_error ||=
            error_response(t('api.responses.groups.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
        end

        def subgroup_not_found_error
          @subgroup_not_found_error ||=
            error_response(t('api.responses.subgroups.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
        end

        def approval_not_found_error
          @approval_not_found_error ||=
            error_response(
              t('api.responses.group_subgroup_approval.not_found'),
              Showoff::ResponseCodes::OBJECT_NOT_FOUND
            )
        end
      end
    end
  end
end

# frozen_string_literal: true

module Api
  module V1
    module Groups
      class SubgroupsController < ApiController
        before_action :check_group_owned_by_current_user, only: %i[create update destroy]
        before_action :check_group_presence,              only: %i[index show approved pending]
        before_action :check_subgroup_presence,           only: %i[show update destroy]

        def approved
          subgroups = group.approved_subgroups
          subgroups_paginated = subgroups.order(id: :desc).limit(limit).offset(offset)

          success_response(
            count: subgroups.count,
            events: serialized_resource(subgroups_paginated, ::Subgroups::OverviewSerializer)
          )
        end

        def pending
          subgroups = group.pending_subgroups
          subgroups_paginated = subgroups.order(id: :desc).limit(limit).offset(offset)

          success_response(
            count: subgroups.count,
            events: serialized_resource(subgroups_paginated, ::Subgroups::OverviewSerializer)
          )
        end

        def create
          subgroup = Group.new(subgroup_params) { |g| g.owner = current_api_user }

          if subgroup.transaction do
               subgroup.save &&
               group.group_subgroup_approvals.build(subgroup: subgroup, user: current_api_user).save
             end
            created_response(subgroup: serialized_resource(subgroup, ::Subgroups::OverviewSerializer))
          else
            active_record_error_response(subgroup)
          end
        end

        def update
          if subgroup.update(subgroup_params)
            success_response(subgroup: serialized_resource(subgroup, ::Subgroups::OverviewSerializer))
          else
            active_record_error_response(subgroup)
          end
        end

        def show
          success_response(
            subgroup: serialized_resource(subgroup, ::Subgroups::OverviewSerializer)
          )
        end

        def destroy
          if subgroup.destroy
            subgroups = group.subgroups.active
            success_response(subgroups: serialized_resource(subgroups, ::Subgroups::OverviewSerializer))
          else
            active_record_error_response(subgroup)
          end
        end

        private

        def check_group_owned_by_current_user
          group_not_found_response if group_owned_by_current_user.blank?
        end

        def check_group_presence
          group_not_found_response if group.blank?
        end

        def check_subgroup_presence
          subgroup_not_found_response if subgroup.blank?
        end

        def group_owned_by_current_user
          @group_owned_by_current_user ||=
            current_api_user.owned_groups.active.where(groups: { id: params[:group_id] }).last
        end

        def group
          @group ||= Group.active.where(id: params[:group_id]).last
        end

        def subgroup
          @subgroup ||= group.subgroups.active.where(groups: { id: params[:id] }).last
        end

        def subgroup_params
          params.require(:subgroup).permit!
        end

        def subgroup_not_found_response
          @subgroup_not_found_response ||=
            error_response(t('api.responses.subgroups.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
        end

        def group_not_found_response
          @group_not_found_response ||=
            error_response(t('api.responses.groups.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
        end
      end
    end
  end
end

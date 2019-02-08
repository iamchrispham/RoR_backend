# frozen_string_literal: true

module Api
  module V1
    module Groups
      class GroupsController < ApiController
        before_action :check_group_presence, only: %i[show update destroy societies own_societies_by_parent]
        before_action :check_ownership, only: %i[update destroy]

        def index
          groups = current_api_user.groups.active
          success_response(
            count: groups.count,
            groups: serialized_resource(
              groups.order(id: :desc).limit(limit).offset(offset), ::Groups::OverviewSerializer
            )
          )
        end

        def societies
          groups = Group.where(parent: group, category: :society).active
          success_response(
            count: groups.count,
            groups: serialized_resource(
              groups.order(id: :desc).limit(limit).offset(offset), ::Groups::OverviewSerializer
            )
          )
        end

        def own_societies_by_parent
          groups = Group.where(parent: group, category: :society, owner: current_api_user).active
          success_response(
            count: groups.count,
            groups: serialized_resource(
              groups.order(id: :desc).limit(limit).offset(offset), ::Groups::OverviewSerializer
            )
          )
        end

        def own_societies
          groups = Group.where(category: :society, owner: current_api_user).active
          success_response(
            count: groups.count,
            groups: serialized_resource(
              groups.order(id: :desc).limit(limit).offset(offset), ::Groups::OverviewSerializer
            )
          )
        end

        def colleges
          groups = Group.where(category: :college).active
          success_response(
            count: groups.count,
            groups: serialized_resource(
              groups.order(id: :desc).limit(limit).offset(offset), ::Groups::OverviewSerializer
            )
          )
        end

        def own_colleges
          groups = Group.where(category: :college, owner: current_api_user).active
          success_response(
            count: groups.count,
            groups: serialized_resource(
              groups.order(id: :desc).limit(limit).offset(offset), ::Groups::OverviewSerializer
            )
          )
        end

        def create
          group = Group.new(group_params) { |g| g.owner = current_api_user }
          if group.save
            success_response(group: serialized_resource(group, ::Groups::OverviewSerializer))
          else
            active_record_error_response(group)
          end
        end

        def update
          if group.update(group_params)
            success_response(group: serialized_resource(group, ::Groups::OverviewSerializer))
          else
            active_record_error_response(group)
          end
        end

        def show
          success_response(
            group: serialized_resource(group, ::Groups::OverviewSerializer)
          )
        end

        def destroy
          if group.destroy
            groups = current_api_user.groups.active
            success_response(groups: serialized_resource(groups, ::Groups::OverviewSerializer))
          else
            active_record_error_response(groups)
          end
        end

        private

        def check_group_presence
          not_found_error if group.blank?
        end

        def check_ownership
          not_found_error if group.owner != current_api_user
        end

        def group
          @group ||= Group.active.find_by(id: params[:group_id] || params[:id])
        end

        def not_found_error
          error_response(t('api.responses.groups.not_found'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
        end

        def group_params
          params.require(:group).permit!
        end
      end
    end
  end
end

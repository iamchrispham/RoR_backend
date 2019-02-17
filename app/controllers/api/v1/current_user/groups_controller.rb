# frozen_string_literal: true

module Api
  module V1
    module CurrentUser
      class GroupsController < ApiController
        def index
          groups =
            current_api_user
            .owned_groups
            .active
            .where(category: params[:category])
            .order(:name)
            .limit(limit)
            .offset(offset)

          success_response(
            count: groups.count,
            groups: serialized_resource(groups, ::Groups::OverviewSerializer)
          )
        end
      end
    end
  end
end

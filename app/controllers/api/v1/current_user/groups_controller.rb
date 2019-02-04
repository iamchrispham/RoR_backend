# frozen_string_literal: true

module Api
  module V1
    module CurrentUser
      class GroupsController < ApiController
        def normal
          groups =
            current_api_user
            .groups
            .active
            .where(category: :normal)
            .order(:name)
            .limit(limit)
            .offset(offset)

          success_response(
            count: groups.count,
            groups: serialized_resource(groups, ::Groups::OverviewSerializer)
          )
        end

        def meetups
          groups =
            current_api_user
            .groups
            .active
            .where(category: :meetup)
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

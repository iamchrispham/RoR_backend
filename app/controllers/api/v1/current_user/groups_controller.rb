# frozen_string_literal: true

module Api
  module V1
    module CurrentUser
      class GroupsController < ApiController
        def index
          groups = current_api_user.groups.active.limit(limit).offset(offset)
          success_response(groups: serialized_resource(groups, ::Groups::OverviewSerializer))
        end
      end
    end
  end
end

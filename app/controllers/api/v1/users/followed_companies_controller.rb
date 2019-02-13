module Api
  module V1
    module Users
      class FollowedCompaniesController < ApiController
        def index
          success_response(
            count: current_api_user.followed_companies.count,
            companies: current_api_user.followed_companies.ordered_by_name.limit(limit).offset(offset).map { |followed_companies| followed_companies.cached(current_api_user, type: :feed) }
          )
        end
      end
    end
  end
end

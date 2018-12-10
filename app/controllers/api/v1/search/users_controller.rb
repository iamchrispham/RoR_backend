module Api
  module V1
    module Search
      class UsersController < ApiController
        def create
          users = User.active.where.not(id: current_api_user.id).for_term(search_params[:term]).ordered_by_name.limit(params[:limit]).offset(params[:offset])
          success_response(users: users.map { |user| user.cached(current_api_user, type: :public) })
        end

        private

        def search_params
          params.require(:search).permit!
        end
      end
    end
  end
end

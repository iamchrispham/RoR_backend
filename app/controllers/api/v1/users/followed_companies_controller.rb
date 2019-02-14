module Api
  module V1
    module Users
      class FollowedCompaniesController < ApiController
        before_action :set_company, only: [:create, :destroy]

        def index
          success_response(
            count: current_api_user.followed_companies.count,
            companies: current_api_user.followed_companies.ordered_by_name.limit(limit).offset(offset).map { |followed_companies| followed_companies.cached(current_api_user, type: :feed) }
          )
        end

        def create
          followed = current_api_user.users_followed_companies.new(company_id: @company.id)
          if followed.save
            success_response()
          else
            active_record_error_response(followed)
          end
        end

        def destroy
          current_api_user.followed_companies.delete(@company)
          success_response()
        end

        private

        def set_company
          @company ||= Company.find_by(id: params[:company_id] || params[:id])
        end
      end
    end
  end
end

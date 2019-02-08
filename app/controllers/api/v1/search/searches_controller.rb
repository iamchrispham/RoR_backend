module Api
  module V1
    module Search
      class SearchesController < ApiController
        def show
          allowed_object_types = %w[users companies events groups]
          response = (search_params[:object_types_for_search] & allowed_object_types).each_with_object({}) do |object_type, response|
            response[object_type] = search(object_type)
          end
                    
          success_response(response)
        end

        private

        def search_params
          params.require(:search).permit(:term, object_types_for_search: [])
        end

        def search(object_type)
          case object_type
          when 'users'
            @users = User.active.where.not(id: current_api_user.id).for_term(search_params[:term]).map { |user| user.cached(current_api_user, type: :public) }
          when 'companies'
            @companies = Company.active.search_by_title(search_params[:term]).map { |company| company.cached(current_api_user, type: :public) }
          when 'events'
            @events = Event.active.title_matching(search_params[:term])
          when 'groups'
            @groups = Group.active.search_by_name(search_params[:term])
          end
        end
      end
    end
  end
end

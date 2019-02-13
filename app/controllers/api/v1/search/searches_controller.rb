module Api
  module V1
    module Search
      class SearchesController < ApiController
        def create
          if search_params[:object_types_for_search].present? && search_params[:term].present?
            allowed_object_types = %w[users companies events groups]
            response = (search_params[:object_types_for_search] & allowed_object_types).each_with_object({}) do |object_type, response|
              response[object_type] = serialize_search_results(search(object_type))
            end
            success_response(response)
          else
            error_response((t 'api.responses.searches.empty_request'), Showoff::ResponseCodes::MISSING_ARGUMENT)
          end
        end

        private

        def search_params
          params.require(:search).permit!
        end

        def search(object_type)
          case object_type
          when 'users'
            @users = User.active.where.not(id: current_api_user.id).for_term(search_params[:term])
          when 'companies'
            @companies = Company.active.search_by_title(search_params[:term])
          when 'events'
            @events = Event.active.title_matching(search_params[:term])
          when 'groups'
            @groups = Group.active.search_by_name(search_params[:term])
          end
        end

        def serialize_search_results(collection)
          ActiveModelSerializers::SerializableResource.new(collection, each_serializer: Searches::PublicSerializer)
        end
      end
    end
  end
end

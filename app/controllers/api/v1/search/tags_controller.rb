module Api
  module V1
    module Search
      class TagsController < ApiController
        skip_before_filter :doorkeeper_authorize!, :current_api_user

        def create
          tag = Tag.sanitize_tag(search_params[:term])

          tags = Tag.matching(tag).limit(params[:limit]).offset(params[:offset]).order(:text)
          success_response(tags: serialized_resource(tags.uniq!, ::Tags::TagSerializer))
        end

        private

        def search_params
          params.require(:search).permit!
        end
      end
    end
  end
end

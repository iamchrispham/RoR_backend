module Api
  module V1
    module Tags
      class TagsController < ApiController
        skip_before_filter :doorkeeper_authorize!

        def index
          tags = Tag.popular.limit(params[:limit]).offset(params[:offset])
          success_response(tags: serialized_resource(tags, ::Tags::TagSerializer))
        end
      end
    end
  end
end

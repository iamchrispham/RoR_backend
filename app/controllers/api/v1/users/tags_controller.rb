module Api
  module V1
    module Users
      class TagsController < ApiController
        def index
          tag = Tag.sanitize_tag(params[:term])

          user_tags = current_api_user.tags.matching(tag)
          tags = Tag.matching(tag).limit(params[:limit]).offset(params[:offset])

          success_response(user_tags: serialized_resource(user_tags, ::Tags::TagSerializer), tags: serialized_resource(tags, ::Tags::TagSerializer))
        end
      end
    end
  end
end

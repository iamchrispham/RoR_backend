module Api
  module V1
    module Search
      class TagsController < ApiController
        skip_before_filter :doorkeeper_authorize!, :current_api_user

        def create
          allowed_objects_types = %w[companies groups]
          sanitized_object_types = (search_params[:object_types_for_search] & allowed_objects_types)
          response = (search_params[:object_types_for_search] & allowed_objects_types).each_with_object({}) do |object_type, response|
            Tag.matching(Tag.sanitize_tag(search_params[:term])).uniq!.each do |tag|    
              class_name = object_type.classify
              collection = class_name.constantize.find(tag.tagged_objects.where(taggable_type: class_name).pluck(:taggable_id))
              if collection.any?
                response.merge!(object_type => []) unless response.key?(object_type)
                response[object_type] << {tag.text => ActiveModelSerializers::SerializableResource.new(collection, each_serializer: ::Searches::PublicSerializer)}
              end
            end
          end
          success_response(response)
        end

        private

        def search_params
          params.require(:search).permit!
        end
      end
    end
  end
end

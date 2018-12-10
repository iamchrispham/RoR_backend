module Showoff
  module Helpers
    module SerializationHelper
      def serialized_resource(resource, serializer, options = {})
        return nil if resource.nil?
        options[:serializer] = serializer
        if resource.is_a?(Array) || resource.is_a?(::ActiveRecord::Relation)
          ::ActiveModel::Serializer::CollectionSerializer.new(resource, options)
        else
          ::ActiveModelSerializers::SerializableResource.new(resource, options)
        end
      end
    end
  end
end

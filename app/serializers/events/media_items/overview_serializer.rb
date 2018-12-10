module Events
  module MediaItems
    class OverviewSerializer < ApiSerializer
      attributes :id, :type, :images, :videos, :updated_at

      def images
        object.formatted_images
      end
    end
  end
end

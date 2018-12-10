module Events
  module Timelines
    module Items
      module MediaItems
        class OverviewSerializer < ApiSerializer
          attributes :id, :type, :images, :videos, :updated_at, :text

          def images
            object.formatted_images
          end
        end
      end
    end
  end
end

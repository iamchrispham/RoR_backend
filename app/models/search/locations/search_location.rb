module Search
  module Locations
    class SearchLocation
      include ActiveModel::Serialization

      attr_reader :id, :name, :address, :latitude, :longitude, :country, :annotation_radius, :country

      def initialize(search_result)
        @annotation_radius = Api::Search::Events::DEFAULT_RADIUS
      end
    end

  end
end

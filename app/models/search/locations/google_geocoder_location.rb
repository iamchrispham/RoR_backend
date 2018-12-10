module Search
  module Locations
    class GoogleGeocoderLocation < SearchLocation
      include ActiveModel::Serialization

      def initialize(search_result)
        @name = search_result.address
        @address = search_result.address
        @latitude, @longitude = search_result.coordinates
      end
    end

  end
end

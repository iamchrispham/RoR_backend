module Search
  module Locations
    class GooglePlaceLocation < SearchLocation

      def initialize(search_result)
        super(search_result)

        @id = search_result.id
        @name = search_result.name
        @address = search_result.formatted_address
        @latitude = search_result.lat
        @longitude = search_result.lng
        @country = search_result.country
      end
    end

  end
end

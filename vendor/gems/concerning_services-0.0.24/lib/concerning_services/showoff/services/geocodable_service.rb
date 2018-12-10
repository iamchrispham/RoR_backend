module Showoff
  module Services
    class GeocodableService < Base
      DEFAULT_DISTANCE = 10

      def self.search(collection, options)
        latitude = options[:latitude].to_f if options[:latitude]
        longitude = options[:longitude].to_f if options[:longitude]

        distance = options[:distance] || DEFAULT_DISTANCE

        center_point = [latitude, longitude]
        bounding_box = Geocoder::Calculations.bounding_box(center_point, distance, unit: :km)

        results = collection.name.constantize.none

        if latitude && longitude && collection.respond_to?(:within_bounding_box)
          results = collection.within_bounding_box(bounding_box)
        end

        results
      end
    end
  end
end

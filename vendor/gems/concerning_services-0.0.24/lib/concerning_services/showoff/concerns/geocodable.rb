module Showoff
  module Concerns
    module Geocodable
      extend ActiveSupport::Concern

      included do
        reverse_geocoded_by :latitude, :longitude do |obj, results|
          if results.any?
            geo = results.first
            obj.address = geo.address
          end
        end

        geocoded_by :address do |obj, results|
          if results.any?
            geo = results.first
            obj.latitude = geo.latitude
            obj.longitude = geo.longitude
          end
        end

        after_validation :reverse_geocode, if: ->(obj) { (obj.latitude.present? && obj.latitude_changed?) || (obj.longitude.present? && obj.longitude_changed?) || (obj.latitude.present? && obj.longitude.present? && obj.address.nil?) }
        after_validation :geocode, if: ->(obj) { obj.address.present? && obj.address_changed? && !(obj.latitude_changed? || obj.longitude_changed?) }
      end

      def coordinates
        { latitude: latitude, longitude: longitude }
      end
    end
  end
end

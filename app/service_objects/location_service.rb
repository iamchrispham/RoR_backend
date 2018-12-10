class LocationService < ApiService
  include Api::CacheHelper
  include Api::ErrorHelper

  attr_reader :latitude, :longitude, :term

  ############ Location Lookup ############
  def lookup(params)
    @latitude = params[:latitude]
    @longitude = params[:longitude]
    cached_object(lookup_cache_key(@latitude, @longitude), :lookup_results)
  end

  def lookup_cache_key(latitude, longitude)
    "go_api_location_lookup_#{latitude}_#{longitude}"
  end

  def lookup_results
    location = Geocoder.search("#{latitude}, #{longitude}").first
    return blank_lookup if location.blank?
    {
      location: {
        address: location.address || I18n.t('api.responses.unknown_field'),
        street: location.street_address || I18n.t('api.responses.unknown_field'),
        state: location.state || I18n.t('api.responses.unknown_field'),
        postal_code: location.postal_code || I18n.t('api.responses.unknown_field'),
        city: location.city || I18n.t('api.responses.unknown_field'),
        country: location.country || I18n.t('api.responses.unknown_field'),
        coordinates: {
          latitude: location.latitude || 0,
          longitude: location.longitude || 0
        }
      }
    }
  end

  def blank_lookup
    {
      location: {
        address: I18n.t('api.responses.unknown_field'),
        street: I18n.t('api.responses.unknown_field'),
        state: I18n.t('api.responses.unknown_field'),
        postal_code: I18n.t('api.responses.unknown_field'),
        city: I18n.t('api.responses.unknown_field'),
        country: I18n.t('api.responses.unknown_field'),
        coordinates: {
          latitude: 0,
          longitude: 0
        }
      }
    }
  end

  ############ Location Search ############
  def search(params)
    @latitude = params[:latitude]
    @longitude = params[:longitude]
    @term = params[:term]

    cached_object(search_cache_key(@latitude, @longitude, @term), :search_results)
  rescue StandardError => e
    report_error(e)
  end

  def search_results
    places_client = GooglePlaces::Client.new(ENV['GOOGLE_PLACES_API_KEY'])
    options = location_params(@latitude, @longitude, @term)

    results = []
    radius = Api::ServiceConstants::Geocoder::POPULAR_DISTANCE * 1000

    if (@latitude && @longitude) || @term
      if @term.blank? || @term.length.zero?
        options[:radius] = radius
        results.concat(places_client.spots(@latitude, @longitude, options).collect { |spot| places_client.spot(spot.place_id) }.map { |result| Search::Locations::GooglePlaceLocation.new(result) })
      else
        google_results = GooglePlaces::Prediction.list_by_input(@term, ENV['GOOGLE_PLACES_API_KEY'], lat: @latitude.to_f, lng: @longitude.to_f, radius: radius, components: '')
        results.concat(google_results.collect { |spot| places_client.spot(spot.place_id) }.map { |result| Search::Locations::GooglePlaceLocation.new(result) })
      end
    end

    results.as_json
  rescue StandardError
    []
  end

  def search_cache_key(latitude, longitude, term)
    options = location_params(latitude, longitude, term)
    "go_api_search_location_#{options.as_json}"
  end

  private

  def location_params(latitude, longitude, name = nil)
    distance = Api::ServiceConstants::Geocoder::DEFAULT_DISTANCE * 1000

    options = { radius: distance, rankby: 'distance' }
    options[:location] = "#{latitude},#{longitude}" if latitude.present? && longitude.present?
    options[:name] = name unless name.nil?
    options
  end
end

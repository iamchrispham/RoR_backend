module Api
  module V1
    module Search
      class LocationsController < ApiController
        def create
          locations = LocationService.new.search(search_params)
          success_response(locations: locations)
        end

        private

        def search_params
          params.require(:search).permit!
        end
      end
    end
  end
end

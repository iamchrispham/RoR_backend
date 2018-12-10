module Api
  module V1
    module Search
      class LookupsController < ApiController

        def create
          locations = LocationService.new.lookup(search_params)
          success_response(locations)
        end


        private
        def search_params
          params.require(:search).permit!
        end

      end
    end
  end
end

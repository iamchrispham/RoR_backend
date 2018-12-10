module Api
  module RequestHelper
    def ip_location(request)
      return nil if request.blank?
      if Rails.env.development?
        Geocoder.search(request.remote_ip).first
      else
        request.location
      end
    end
  end
end

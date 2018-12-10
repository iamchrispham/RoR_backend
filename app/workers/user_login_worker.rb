require 'sidekiq'

class UserLoginWorker
  include Sidekiq::Worker
  include Api::ErrorHelper
  include UserSessionHelper

  sidekiq_options queue: :default, retry: 3

  def perform(user_id, token_id, current_request_ip, current_request_user_agent, current_request_content_type)
    user = User.find_by(id: user_id)
    token = Doorkeeper::AccessToken.find_by(id: token_id)

    location = Geocoder.search(current_request_ip).first
    if location
      latitude = location.lat
      longitude = location.lon
      isp = location.isp
      address = location.address
    else
      address = nil
      latitude = nil
      longitude = nil
      isp = nil
    end

    ip_address = current_request_ip
    application = token.application unless token.blank?
    application_id = application.id unless application.blank?
    token_id = token.id unless token.blank?

    UserLogin.create(
      user: user,
      ip: ip_address,
      latitude: latitude,
      longitude: longitude,
      location: address,
      isp: isp,
      user_agent: current_request_user_agent,
      application_id: application_id,
      access_token_id: token_id,
      request: request_hash(token, location, current_request_ip, current_request_content_type, current_request_user_agent)
    )
  rescue StandardError => e
    report_error(e)
  end
end

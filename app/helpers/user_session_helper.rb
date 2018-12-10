module UserSessionHelper
  include Api::RequestHelper

  def store_request_in_thread
    RequestStore.store[:current_request] = request
  end

  def current_request
    RequestStore.store[:current_request]
  end

  def current_request_ip
    return nil if current_request.blank?
    current_request.remote_ip
  end

  def current_request_user_agent
    return nil if current_request.blank?
    current_request.user_agent
  end

  def current_request_content_type
    return nil if current_request.blank?
    current_request.headers['Content-Type']
  end

  def currency_for_session
    location = ip_location(current_request)
    if location
      country_code = location.country_code

      country_object ||= ISO3166::Country.find_country_by_alpha2(country_code)

      if country_object.currency.symbol
        country_object.currency.symbol
      else
        currency
      end
    else
      MoneyRails.default_currency.symbol
    end

  end

  def record_login(user, token)
    UserLoginWorker.perform_async(user.id, token.id, current_request_ip, current_request_user_agent, current_request_content_type)
  end

  def request_hash(token = nil, location, ip, content_type, user_agent)
    if location
      latitude = location.lat
      longitude = location.lon
      isp = location.isp
      address = location.address
      country = location.country
      country_code = location.country_code
      city = location.city
      org = location.org
      region_name = location.region_name
    else
      latitude = nil
      longitude = nil
      isp = nil
      address = nil
      country = nil
      country_code = nil
      city = nil
      org = nil
      region_name = nil
    end

    ip_address = ip
    application = token.application unless token.blank?
    application_name = application.name if application.present?
    token_id = token.id unless token.blank?

    {
        ip: ip_address,
        content_type: content_type,
        user_agent: user_agent,
        latitude: latitude,
        longitude: longitude,
        address: address,
        isp: isp,
        country: country,
        country_code: country_code,
        city: city,
        org: org,
        region: region_name,
        application_name: application_name,
        access_token_id: token_id,


    }
  end
end

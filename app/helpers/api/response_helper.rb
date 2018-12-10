module Api
  module ResponseHelper
    def default_response(code, message, data)
      { code: code, message: message, data: data.as_json }
    end

    def unauthorized_response
      default_response = default_response(Showoff::ResponseCodes::NO_AUTHENTICATED_USER, (I18n.t 'api.responses.unauthorized'), nil)
      render json: default_response, status: Showoff::ResponseCodes::STATUS[Showoff::ResponseCodes::NO_AUTHENTICATED_USER]
    end

    def doorkeeper_unauthorized_render_options(error: nil)
      default_response = default_response(Showoff::ResponseCodes::NO_AUTHENTICATED_USER, (I18n.t 'api.responses.unauthorized'), nil)
      { json: default_response }
    end

    def missing_argument_response(error)
      response = default_response(Showoff::ResponseCodes::MISSING_ARGUMENT, (I18n.t 'api.responses.missing_parameter', param: error.param), nil)
      render json: response, status: Showoff::ResponseCodes::STATUS[Showoff::ResponseCodes::MISSING_ARGUMENT]
    end

    def doorkeeper_status_for_error(_error, _option)
      Showoff::ResponseCodes::STATUS[Showoff::ResponseCodes::NO_AUTHENTICATED_USER]
    end

    def error_response(message, status = 0)
      default_response = default_response(status, message, nil)
      render json: default_response, status: Showoff::ResponseCodes::STATUS[status]
    end

    def success_response(data = {}, _json_options = {})
      message = (I18n.t 'api.responses.success')
      default_response = default_response(Showoff::ResponseCodes::SUCCESS, message, data)
      render json: default_response, status: Showoff::ResponseCodes::STATUS[Showoff::ResponseCodes::SUCCESS]
    end

    def created_response(data = {})
      default_response = default_response(Showoff::ResponseCodes::CREATED, (I18n.t 'api.responses.success'), data)
      render json: default_response, status: Showoff::ResponseCodes::STATUS[Showoff::ResponseCodes::CREATED]
    end

    def facebook_merge_response(data = {})
      response_code = data[:merge] ? Showoff::ResponseCodes::FACEBOOK_MERGE : Showoff::ResponseCodes::SUCCESS
      default_response = default_response(response_code, (I18n.t 'api.responses.success'), data)
      render json: default_response, status: Showoff::ResponseCodes::STATUS[Showoff::ResponseCodes::SUCCESS]
    end

    def active_record_error_response(resource)
      error_response(resource.errors.full_messages.first, Showoff::ResponseCodes::INVALID_ARGUMENT)
    end
  end
end

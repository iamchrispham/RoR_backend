module Api
  module UserHelper
    def ensure_user_is_active(user)
      if user.active && !user.suspended
        yield
      elsif !user.active
        error_response(t('api.responses.users.inactive'), Showoff::ResponseCodes::INVALID_ARGUMENT)
      elsif user.suspended
        error_response(t('api.responses.users.suspended'), Showoff::ResponseCodes::INVALID_ARGUMENT)
      end
    end
  end
end

module Showoff
  module API
    module ResponseCodes
      SUCCESS = 0
      ENDPOINT_NOT_VALID = 1
      MISSING_ARGUMENT = 2
      INVALID_ARGUMENT = 3
      OBJECT_NOT_FOUND = 4
      INTERNAL_ERROR = 5
      NO_AUTHENTICATED_USER = 10
      INVALID_API_KEY = 14
      INVALID_CREDENTIALS = 100
      ACCOUNT_DISABLED = 102

      STATUS = {
        SUCCESS => 200,
        ENDPOINT_NOT_VALID => 400,
        MISSING_ARGUMENT => 400,
        INVALID_ARGUMENT => 422,
        OBJECT_NOT_FOUND => 404,
        NO_AUTHENTICATED_USER => 401,
        INVALID_API_KEY => 400,
        INTERNAL_ERROR => 500,
        INVALID_CREDENTIALS => 601,
        ACCOUNT_DISABLED => 603
      }.freeze
    end
  end
end

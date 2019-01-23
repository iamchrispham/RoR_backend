module Api
  VERSION = 1.0

  module ActiveRecord
    DEFAULT_OFFSET = 0
    DEFAULT_LIMIT = 20
  end

  module ServiceConstants
    module Geocoder
      POPULAR_DISTANCE = 10
      DEFAULT_DISTANCE = 20
      SEARCH_DISTANCE = 100
    end

    module NearbyAlerts
      DEFAULT_RADIUS = 500.freeze
      DWELL_TIME = (60*5).freeze
    end
  end

  module Search
    module Events
      DEFAULT_RADIUS = 750
      DEFAULT_GEOMETRY_DISTANCE = 2.5
      RANDOM_OFFSET_DISTANCE = 0.25
    end
  end

  module Home
    module RecentSearches
      MINIMUM_DAYS = 30
    end
    module Feed
      module Collections
        MINIMUM_COUNT = 5
      end
    end
  end

  module Emails
    DEFAULT_DATE_FORMAT = '%d %b %y'
    DEFAULT_TIME_FORMAT = '%d %b %y at %H:%M %Z'
    TIME_FORMAT =  '%H:%M %Z'
  end

  module Feeds
    module Items
      module Actions
        EVENT_ATTENDEE = 'event_attendee'
        EVENT_SHARE = 'event_share'
        EVENT_TIMELINE_ITEM_POST = 'event_timeline_item_post'
        EVENT_TIMELINE_ITEM_COMMENT = 'event_timeline_item_comment'
        EVENT_TIMELINE_ITEM_LIKE = 'event_timeline_item_like'
      end
    end
  end

end


module Showoff
  module Alerts
    module AlertTypes
    end
  end
  module ResponseCodes
    USER_NO_CREDIT_CARD_PRESENT = 10002
    CREATED = 6

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
        ACCOUNT_DISABLED => 603,
        FACEBOOK_MERGE => 200,
        USER_NO_CREDIT_CARD_PRESENT => 500
    }.freeze
  end
end

module General
  PHONE_FORMAT_REGEXP = /\A\+?\d+\z/.freeze
end

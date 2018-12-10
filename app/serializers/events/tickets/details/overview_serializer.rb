module Events
  module Tickets
    module Details
      class OverviewSerializer < ApiSerializer
        include Rails.application.routes.url_helpers

        attributes :id, :url, :original_url

        def url
          view_api_v1_event_tickets_url(object.event, host: ENV['APPLICATION_HOST'])
        end

        def original_url
          object.url
        end

      end
    end
  end
end

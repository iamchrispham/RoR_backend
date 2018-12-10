module Events
  module Attendees
    module Requests
      class OverviewSerializer < ApiSerializer
        attributes :id, :status, :updated_at
      end
    end
  end
end

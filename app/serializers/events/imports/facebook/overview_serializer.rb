module Events
  module Imports
    module Facebook
      class OverviewSerializer < ApiSerializer
        attributes :id, :failed_count, :imported_count, :status, :message
      end
    end
  end
end

module Feeds
  module Actions
    class OverviewSerializer < ApiSerializer
      attributes :id, :action, :slug, :updated_at
    end
  end
end

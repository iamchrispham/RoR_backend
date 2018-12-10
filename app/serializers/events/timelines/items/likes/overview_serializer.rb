module Events
  module Timelines
    module Items
      module Likes
        class OverviewSerializer < ApiSerializer
          attributes :id, :event_timeline_item_id, :user_id
        end
      end
    end
  end

end

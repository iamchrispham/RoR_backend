module Events
  module Timelines
    module Items
      module Comments
        class OverviewSerializer < ApiSerializer
          attributes :id, :user, :content, :active, :created_at, :updated_at, :tags

          def user
            object.user.cached(instance_user, type: :feed)
          end
        end
      end
    end
  end
end

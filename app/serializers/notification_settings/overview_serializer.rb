module NotificationSettings
  class OverviewSerializer < ApiSerializer
    attributes :id, :name, :description, :slug
  end
end

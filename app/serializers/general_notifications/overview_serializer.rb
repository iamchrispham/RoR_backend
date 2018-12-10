module GeneralNotifications
  class OverviewSerializer < ApiSerializer
    attributes :id, :title, :message, :created_at, :platform

    def platform
      serialized_resource(object.platform, ::Platforms::PublicSerializer)
    end
  end
end

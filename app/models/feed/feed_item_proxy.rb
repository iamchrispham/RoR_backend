module Feed
  class FeedItemProxy
    include ActiveModel::Serialization

    attr_reader :id, :event, :media, :type, :context, :updated_at

    def initialize(event_timeline_item)
      @id = event_timeline_item.id
      @event = nil
      @media = event_timeline_item
      @type = :event_timeline_item
      @context = nil
      @updated_at = @media.updated_at
    end
  end
end

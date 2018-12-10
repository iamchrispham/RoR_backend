module Feeds
  module FeedActionable
    extend ActiveSupport::Concern

    included do
      include Showoff::Helpers::SerializationHelper

      has_one :feed_item_context, as: :object

      after_commit :create_feed_item_if_required
    end

    def can_create_feed_item?
      raise NotImplementedError
    end

    def create_feed_item_if_required
      return if !can_create_feed_item? || feed_item_context.present?
      FeedItemWorker.perform_async(self.class.to_s, id)
    end

    def feed_item_object
      raise NotImplementedError
    end

    def feed_item_action
      raise NotImplementedError
    end

    def feed_item_subscribers
      raise NotImplementedError
    end

    def feed_item_actor
      raise NotImplementedError
    end

  end
end


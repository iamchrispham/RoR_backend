module Feeds
  module Feedable
    extend ActiveSupport::Concern

    included do
      has_many :feed_item_contexts, as: :actor
      has_many :carried_out_feed_item_actions, through: :feed_item_contexts, source: :feed_item_action
      has_many :owned_feed_items, through: :feed_item_contexts, source: :feed_item

      has_many :user_feed_items
      has_many :subscribed_feed_items, -> { order( 'feed_items.updated_at desc' ).uniq }, through: :user_feed_items, source: :feed_item
    end
  end
end


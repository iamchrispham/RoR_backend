require 'sidekiq'

class FeedItemWorker
  include Sidekiq::Worker
  include Api::ErrorHelper
  include UserSessionHelper

  sidekiq_options queue: :default, retry: 3

  def perform(klass, id)
    object = klass.constantize.find_by(id: id)
    if object.present?
      # create context
      feed_item_context = FeedItemContext.new(
        actor: object.feed_item_actor,
        feed_item_action: object.feed_item_action,
        object: object
      )

      # create feed item
      feed_item = FeedItem.new(object: object.feed_item_object, feed_item_context: feed_item_context)
      feed_item.users = object.feed_item_subscribers

      if feed_item.valid?
        feed_item.save!
      end
    end
  rescue StandardError => e
    report_error(e)
  end
end

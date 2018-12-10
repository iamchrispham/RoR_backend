class EventTimelineItemLike < ActiveRecord::Base
  include Feeds::FeedActionable

  belongs_to :user
  belongs_to :event_timeline_item

  has_one :event_timeline_item_like_notifier, dependent: :destroy
  after_commit :create_event_timeline_item_like_notifier, on: :create

  validates :user_id, uniqueness: { scope: :event_timeline_item_id }
  validates :user, :event_timeline_item, presence: true

  after_create :increment_totals
  before_destroy :decrement_totals

  after_save :update_caches
  after_destroy :update_caches

  def update_caches
    user&.update_caches
  end

  def increment_totals
    event_timeline_item.update_attributes(number_of_likes: event_timeline_item.number_of_likes + 1)
  end

  def decrement_totals
    event_timeline_item.update_attributes(number_of_likes: event_timeline_item.number_of_likes - 1)
  end

  #remove timeline items
  before_destroy :deactivate_feed_items_if_required
  def deactivate_feed_items_if_required
    FeedItem.where(feed_item_context: FeedItemContext.find_by(object: self)).deactivate_all
  end


  # FeedActionable
  def can_create_feed_item?
    true
  end

  def feed_item_action
    FeedItemAction.find_by(slug: ::Api::Feeds::Items::Actions::EVENT_TIMELINE_ITEM_LIKE)
  end

  def feed_item_subscribers
    event_timeline_item.event.attending_users.where.not(id: user.id)
  end

  def feed_item_actor
    user
  end

  def feed_item_object
    event_timeline_item
  end

end

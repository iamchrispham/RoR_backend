class EventTimelineItemComment < ActiveRecord::Base
  include Feeds::FeedActionable

  include Showoff::Helpers::SerializationHelper
  include Taggable

  include Reportable
  include Periodable

  belongs_to :user
  belongs_to :event_timeline_item

  has_one :event_timeline_item_comment_notifier, dependent: :destroy
  after_commit :create_event_timeline_item_comment_notifier, on: :create

  scope :active, -> {
    joins(:user, :event_timeline_item)
        .where(active: true, users: {active: true, suspended: false}, event_timeline_items: {active: true})
  }

  scope :inactive, -> {
    joins(:user, :event_timeline_item)
        .where(active: false, users: {active: true, suspended: false}, event_timeline_items: {active: true})
  }

  scope :for_term, -> (text) { where('content ILIKE ?', "%#{text}%") }

  taggable_attributes :content
  taggable_owner :user

  after_report :deactivate_if_report_threshold_breached

  after_create :increment_totals
  before_destroy :decrement_totals

  after_save :update_caches
  after_destroy :update_caches

  def update_caches
    user&.update_caches
  end

  def increment_totals
    event_timeline_item.update_attributes(number_of_comments: event_timeline_item.number_of_comments + 1)
  end

  def decrement_totals
    event_timeline_item.update_attributes(number_of_comments: event_timeline_item.number_of_comments - 1)
  end

  #remove timeline items
  before_destroy :deactivate_feed_items_if_required
  def deactivate_feed_items_if_required
    FeedItem.where(feed_item_context: FeedItemContext.find_by(object: self)).deactivate_all
  end


  def self.report_threshold
    ENV.fetch('EVENT_TIMELINE_ITEM_COMMENT_REPORT_THRESHOLD', 100).to_i
  end

  def deactivate_if_report_threshold_breached
    update_attributes(active: false, inactive_at: Time.now) if reports.unconsidered.count >= EventTimelineItemComment.report_threshold
  end


  # FeedActionable
  def can_create_feed_item?
    true
  end

  def feed_item_action
    FeedItemAction.find_by(slug: ::Api::Feeds::Items::Actions::EVENT_TIMELINE_ITEM_COMMENT)
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

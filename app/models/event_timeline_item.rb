class EventTimelineItem < ActiveRecord::Base
  include Feeds::FeedActionable
  include Indestructable
  include Reportable

  belongs_to :event
  belongs_to :user

  has_many :event_timeline_item_media_items
  has_many :feed_items, as: :object

  has_many :event_timeline_item_likes
  has_many :event_timeline_item_comments

  validates :event, :user, presence: true
  after_report :deactivate_if_report_threshold_breached
  before_save :deactivate_feed_items_if_required

  after_save :update_caches
  after_destroy :update_caches

  scope :with_media, -> {
    joins(:event_timeline_item_media_items)
      .where('event_timeline_item_media_items.image_file_name IS NOT NULL OR event_timeline_item_media_items.video_file_name IS NOT NULL ')
  }

  scope :without_media, -> {
    joins('LEFT OUTER JOIN event_timeline_item_media_items on event_timeline_item_media_items.event_timeline_item_id = event_timeline_items.id')
      .where('event_timeline_item_media_items.image_file_name IS NULL AND event_timeline_item_media_items.video_file_name IS NULL ')
  }

  def update_caches
    user&.update_caches
  end

  def media_items
    event_timeline_item_media_items
  end

  # FeedActionable
  def can_create_feed_item?
    true
  end

  def feed_item_action
    FeedItemAction.find_by(slug: ::Api::Feeds::Items::Actions::EVENT_TIMELINE_ITEM_POST)
  end

  def feed_item_subscribers
    event.attending_users.where.not(id: user.id)
  end

  def feed_item_actor
    user
  end

  def feed_item_object
    self
  end

  private
  def deactivate_feed_items_if_required
    feed_items.deactivate_all if active_changed? && !active
  end

  def deactivate_if_report_threshold_breached
    if reports.unconsidered.count >= EventTimelineItem.report_threshold
      update_attributes(active: false)
      feed_items.deactivate_all
    end
  end

  def self.report_threshold
    ENV.fetch('EVENT_TIMELINE_ITEM_REPORT_THRESHOLD', 100).to_i
  end


end

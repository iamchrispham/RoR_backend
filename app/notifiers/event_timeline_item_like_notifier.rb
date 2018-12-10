class EventTimelineItemLikeNotifier < Showoff::SNS::Notifier::Base
  belongs_to :event_timeline_item_like

  has_one :event_timeline_item, through: :event_timeline_item_like
  has_one :event, through: :event_timeline_item

  validates :event_timeline_item_like, uniqueness: true, presence: true

  after_commit :send_notification, on: :create

  def set_owner
    self.owner = event_timeline_item_like.user
  end

  def self.notification_type
    :event_timeline_item_like
  end

  def should_notify?(target)
    !target.id.eql?(owner.id) && target.notifications_enabled_for('event_timeline_item_like')
  end

  def subscribers
    [event_timeline_item.user]
  end

  def message(_target)
    I18n.t('notifiers.event_timeline_item_like.message',
           user: event_timeline_item_like.user.name,
           event: event.title,
           type: media_type)
  end

  def extra_information(_target)
    {
      event_timeline_item_like_id: event_timeline_item_like.id,
      event_timeline_item_id: event_timeline_item.id,
      event_id: event.id,
      user_id: event_timeline_item_like.user.id
    }
  end

  def resources(target)
    {
      event_timeline_item_like: serialized_resource(event_timeline_item_like, ::Events::Timelines::Items::Likes::OverviewSerializer, user: target),
      event_timeline_item: serialized_resource(event_timeline_item, ::Events::Timelines::Items::OverviewSerializer, user: target),
      event: event.cached(target, type: :feed),
      user: event_timeline_item_like.user.cached(target, type: :feed)
    }
  end

  private

  def media_type
    media_item = event_timeline_item.event_timeline_item_media_items.first

    media_item&.type || :content
  end
end

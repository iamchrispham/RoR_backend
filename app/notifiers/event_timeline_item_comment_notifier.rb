class EventTimelineItemCommentNotifier < Showoff::SNS::Notifier::Base
  belongs_to :event_timeline_item_comment

  has_one :event_timeline_item, through: :event_timeline_item_comment
  has_one :event, through: :event_timeline_item

  validates :event_timeline_item_comment, uniqueness: true, presence: true

  after_commit :send_notification, on: :create

  def set_owner
    self.owner = event_timeline_item_comment.user
  end

  def self.notification_type
    :event_timeline_item_comment
  end

  def should_notify?(target)
    !target.id.eql?(owner.id) && target.notifications_enabled_for('event_timeline_item_comment')
  end

  def subscribers
    [event_timeline_item.user]
  end

  def message(_target)
    I18n.t('notifiers.event_timeline_item_comment.message',
           user: event_timeline_item_comment.user.name,
           event: event.title,
           type: media_type)
  end

  def extra_information(_target)
    {
      event_timeline_item_comment_id: event_timeline_item_comment.id,
      event_timeline_item_id: event_timeline_item.id,
      event_id: event.id,
      user_id: event_timeline_item_comment.user.id
    }
  end

  def resources(target)
    {
      event_timeline_item_comment: serialized_resource(event_timeline_item_comment, ::Events::Timelines::Items::Comments::OverviewSerializer, user: target),
      event_timeline_item: serialized_resource(event_timeline_item, ::Events::Timelines::Items::OverviewSerializer, user: target),
      event: event.cached(target, type: :feed),
      user: event_timeline_item_comment.user.cached(target, type: :feed)
    }
  end

  private

  def media_type
    media_item = event_timeline_item.event_timeline_item_media_items.first
    media_item&.type || :content
  end
end

class EventAttendee < ActiveRecord::Base
  include Feeds::FeedActionable

  belongs_to :event
  belongs_to :user

  validates :event, :user, :status, presence: true

  enum status: %i[maybe_going not_going going invited pending]

  STATUS_ORDERS = [EventAttendee.statuses[:going], EventAttendee.statuses[:maybe_going], EventAttendee.statuses[:invited], EventAttendee.statuses[:not_going]].freeze

  scope :order_by_status, -> {
    order_by = ['CASE']
    STATUS_ORDERS.each_with_index do |role, index|
      order_by << "WHEN status=#{role} THEN #{index}"
    end
    order_by << 'END'
    order(order_by.join(' '))
  }

  has_many :event_attendee_contributions, dependent: :destroy
  has_one :event_attendee_request, dependent: :destroy

  has_one :event_invitation_notifier, dependent: :destroy
  has_one :event_owner_attendee_notifier, dependent: :destroy

  has_one :feed_item, as: :object
  has_one :conversation, through: :event

  after_create :check_requires_attendee_request, :send_notifications
  after_update :check_status
  after_save :check_conversation

  after_save :deactivate_feed_items_if_required

  after_save :update_caches
  after_destroy :update_caches

  def update_caches
    user&.update_caches
    event&.update_caches if status_changed?
  end

  def deactivate_feed_items_if_required
    # only fire this if the status was changed and we're not going
    if status_changed? && not_going?

      # find feed items for friends for previous going to this event status
      feed_item_context = FeedItemContext.find_by(
        actor: feed_item_actor,
        feed_item_action: feed_item_action,
        object: self
      )

      feed_item = FeedItem.find_by(object: feed_item_object, feed_item_context: feed_item_context)
      feed_item&.deactivate!

      # find feed items where friends have attended this event
      user.user_feed_items
          .joins(:feed_item_context)
          .joins(:actor)
          .where(feed_item_contexts: { actor_id: feed_item_subscribers })
          .where(feed_items: { object_id: event.id, object_type: 'Event' }).destroy_all

      # find timeline items for this event for the user
      if event.event_timeline_items.count.nonzero?
        user.user_feed_items
            .joins(:feed_item)
            .where(feed_items: {
                     object_id: event.event_timeline_items.pluck(:id),
                     object_type: 'EventTimelineItem'
                   }).destroy_all
      end

    end
  end

  # Scopes
  scope :valid, -> {
    where.not(id: pending.pluck(:id))
  }

  scope :for_term, ->(text) { joins(:user).where("users.first_name || ' ' || users.last_name ILIKE ? OR users.business_name ILIKE ?", "%#{text}%", "%#{text}%") }

  # Contributions
  def contribution
    event_attendee_contributions.first
  end

  # FeedActionable
  def can_create_feed_item?
    ((going? || maybe_going?) && (user != event.user) && !event.attendance_acceptance_required) ||
      ((going? || maybe_going?) && (user != event.user) && (event.attendance_acceptance_required && event_attendee_request.present? && event_attendee_request.accepted?))
  end

  def feed_item_action
    FeedItemAction.find_by(slug: ::Api::Feeds::Items::Actions::EVENT_ATTENDEE)
  end

  def feed_item_subscribers
    if event.private_event
      user.friends.where(id: event.attending_users.where.not(id: user.id).pluck(:id))
    else
      user.friends
    end
  end

  def feed_item_actor
    user
  end

  def feed_item_object
    event
  end

  private

  def send_notifications
    return if user.eql?(event.user) || event.blank? || (event.present? && !event.persisted?)

    if invited?
      create_event_invitation_notifier
      EventMailer.delay.invite(user.id, event.id)
    elsif (!pending? && !event.attendance_acceptance_required) || (event.attendance_acceptance_required && event_attendee_request.present?)
      create_event_owner_attendee_notifier
    end
  end

  def check_status
    return if user.eql?(event.user_from_event_owner)

    if status_changed? && ((!pending? && !event.attendance_acceptance_required) || (event.attendance_acceptance_required && event_attendee_request.present?))
      event_owner_attendee_notifier.destroy! if event_owner_attendee_notifier.present?
      create_event_owner_attendee_notifier
    end
  end

  def check_requires_attendee_request
    return if user.eql?(event.user)

    if event.attendance_acceptance_required && !invited? && going?
      pending!
      create_event_attendee_request
    end
  end

  def check_conversation
    return if !event.allow_chat || (!status_changed? && !new_record?)

    # Check if we need to create conversation
    if event.conversation.blank? && event.allow_chat
      event.create_event_conversation
    end

    existing_conversation = event.conversation
    if existing_conversation
      if not_going?
        conversation_service.leave_conversation_for_participant(user, existing_conversation.id)
      else
        conversation_service.join_conversation_for_participant(user, existing_conversation.id)
      end
    end
  end

  def conversation_service
    @conversation_service ||= ::Conversations::ConversationsService.new
  end

  def message_service
    @message_service ||= ::Conversations::MessageService.new
  end

  def joined_message_params
    { text: I18n.t('api.responses.conversations.joining_message', user: user.name) }
  end

  def leaving_message_params
    { text: I18n.t('api.responses.conversations.leaving_message', user: user.name) }
  end
end

class EventAttendeeRequest < ActiveRecord::Base
  belongs_to :event_attendee

  enum status: [:pending, :accepted, :rejected]

  validates :event_attendee, :status, presence: true

  has_one :conversation, through: :event_attendee
  has_one :user, through: :event_attendee

  has_one :event_attendee_request_owner_notifier, dependent: :destroy
  has_one :event_attendee_request_response_notifier, dependent: :destroy

  after_save :send_notifications

  after_save :update_caches
  after_destroy :update_caches

  def reject!
    rejected!
    event_attendee.not_going!
  end

  def accept!
    accepted!
    event_attendee.maybe_going!
  end

  def update_caches
    user&.update_caches
  end

  private

  def send_notifications
    event_attendee_request_owner_notifier&.destroy unless pending?

    if pending?
      event_attendee_request_owner_notifier.destroy! if event_attendee_request_owner_notifier.present?
      create_event_attendee_request_owner_notifier
    else
      event_attendee_request_response_notifier.destroy! if event_attendee_request_response_notifier.present?
      create_event_attendee_request_response_notifier
    end
  end
end

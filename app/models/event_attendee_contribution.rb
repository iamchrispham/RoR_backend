class EventAttendeeContribution < ActiveRecord::Base
  include Indestructable

  belongs_to :event_attendee

  delegate :user, to: :event_attendee

  has_one :payment_receipt, class_name: 'Showoff::Payments::Receipt', foreign_key: 'purchase_id'
  has_many :receipts, class_name: 'Showoff::Payments::Receipt', as: :purchase

  monetize :amount_cents, with_currency: lambda { |obj| obj.event_attendee.event.event_ownerable.currency }

  enum status: [:paid, :pending]

  validates :event_attendee, :amount_cents, presence: true

end

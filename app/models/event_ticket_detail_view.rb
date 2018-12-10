class EventTicketDetailView < ActiveRecord::Base
  include Indestructable

  belongs_to :event_ticket_detail
  belongs_to :user

  validates :user, presence: true
end

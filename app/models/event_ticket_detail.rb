class EventTicketDetail < ActiveRecord::Base
  include Tickets::Filterable
  include Indestructable

  has_paper_trail

  belongs_to :event
  has_many :event_ticket_detail_views
  has_many :event_ticket_detail_viewed_users, through: :event_ticket_detail_views, source: :user

  validates :url, presence: true, url: true

  def record_view!(user)
    event_ticket_detail_views.create(user: user)
  end

  scope :for_term, ->(text) { joins(:event).where('event_ticket_details.url ILIKE ? OR events.title ILIKE ? OR events.description ILIKE ?', "%#{text}%", "%#{text}%", "%#{text}%") }

  scope :ordered_by_url, -> {
    reorder('url ASC')
  }

  scope :ordered_by_views, -> {
    joins('LEFT OUTER JOIN event_ticket_detail_views ON event_ticket_detail_views.event_ticket_detail_id = event_ticket_details.id')
        .select('event_ticket_details.*, coalesce(COUNT(DISTINCT event_ticket_detail_views.id), 0) as views_count')
        .group('event_ticket_details.id')
        .reorder('views_count DESC')
  }

end

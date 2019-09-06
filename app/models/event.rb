# frozen_string_literal: true

class Event < ActiveRecord::Base
  default_scope { includes(:event_attendees) }

  include Taggable
  include Indestructable
  include Reportable
  include Showoff::Concerns::Geocodable
  include Events::Filterable

  include Api::CacheHelper
  include Showoff::Helpers::SerializationHelper
  include Currencyable

  alias_attribute :name, :title

  enum review_status: { pending: 0, approved: 1, declined: 2 }

  belongs_to :event_ownerable, polymorphic: true

  has_one :event_contribution_detail, dependent: :destroy
  has_one :event_contribution_type, through: :event_contribution_detail

  has_one :chat, as: :chatable, dependent: :destroy

  has_one :event_ticket_detail

  has_one :event_cancelled_notifier, dependent: :destroy
  has_one :upcoming_event_notifier, dependent: :destroy

  has_many :event_ticket_detail_views, through: :event_ticket_detail
  has_many :event_ticket_detail_viewed_users, through: :event_ticket_detail_views, source: :user

  def contribution_required?
    event_contribution_detail.present?
  end

  has_many :event_media_items

  has_many :event_timeline_items
  has_many :event_timeline_item_media_items, through: :event_timeline_items

  has_many :event_shares
  has_many :shared_with_users, through: :event_shares, source: :users

  has_many :event_attendees
  has_many :invited_users, -> { where(event_attendees: { status: EventAttendee.statuses[:invited] }) }, through: :event_attendees, source: :user
  has_many :attending_users, -> { where(event_attendees: { status: EventAttendee.statuses[:going] }) }, through: :event_attendees, source: :user
  has_many :not_attending_users, -> { where(event_attendees: { status: EventAttendee.statuses[:not_going] }) }, through: :event_attendees, source: :user
  has_many :maybe_attending_users, -> { where(event_attendees: { status: EventAttendee.statuses[:maybe_going] }) }, through: :event_attendees, source: :user

  has_many :notifiable_users, -> { where.not(event_attendees: { status: EventAttendee.statuses[:not_going] }) }, through: :event_attendees, source: :user

  has_many :event_attendee_contributions, through: :event_attendees

  has_many :tagged_events, -> { uniq! }, through: :tagged_objects, source: :taggable, source_type: Event

  has_one :conversation, class_name: 'Conversations::Conversation'

  has_many :event_attendee_requests, through: :event_attendees

  with_options class_name: 'SubgroupEventsApproval', inverse_of: :event, dependent: :destroy do
    has_many :subgroup_events_approvals
    has_many :subgroup_events_approved, -> { active }
    has_many :subgroup_events_pending, -> { inactive }
  end

  taggable_attributes :categories
  taggable_owner :event_ownerable

  after_create :init_chat
  # after_create :create_conversation_if_required

  after_save :create_event_cancelled_notifier_if_necessary

  before_save :ensure_date_time

  before_save :deactivate_event_timeline_items_if_required
  def deactivate_event_timeline_items_if_required
    if active_changed? && !active
      FeedItem.where(object: event_timeline_items).deactivate_all
      FeedItem.where(object: self).deactivate_all
      event_timeline_items.deactivate_all
    end
  end

  validates :title, :description, :time, :date, :latitude, :longitude, :categories, presence: true

  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :price, numericality: { only_integer: true, greater_than: 0 }, if: :price
  validates :event_ownerable, presence: true
  validates :review_status, presence: true, if: :business_event

  scope :order_to_now, -> {
    reorder("events.date_time < current_timestamp ASC, ABS(DATE_PART('day',events.date_time - current_timestamp)) ASC")
  }

  # scopes #TODO change active and inactive scopes
  # scope :active, -> { joins(:user).where(active: true, users: { active: true, suspended: false }) }
  # scope :inactive, -> { joins(:user).where(active: false, users: { active: true, suspended: false }) }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :eighteen_plus, -> { where(eighteen_plus: true) }
  scope :not_eighteen_plus, -> { where(eighteen_plus: false) }
  scope :not_private, -> { where(private_event: false) }
  scope :approved_business_events, -> { where(event_ownerable_type: 'Company').approved }

  scope :title_matching, ->(text) { where('title ILIKE ?', "%#{text}%") }
  scope :description_matching, ->(text) { where('description ILIKE ?', "%#{text}%") }
  scope :for_term, ->(text) { where('events.title ILIKE ? OR events.description ILIKE ?', "%#{text}%", "%#{text}%") }

  scope :mutual_events, ->(user) {
    joins(:event_attendees).where(
      event_attendees: {
        status: EventAttendee.statuses[:going], user_id: user.friends.pluck(:id)
      }
    )
  }

  scope :with_tags, ->(tags) {
    joins(:tags).where(tags: { text: tags })
  }

  scope :starting_at_or_after, ->(start_at) {
    where('date >= ?', start_at)
  }

  scope :ending_at_or_before, ->(end_at) {
    where('date <= ?', end_at)
  }

  scope :budget_range, ->(low_price, top_price) {
    where('price >= ? AND price <= ?', low_price, top_price)
  }

  scope :with_contribution_type, ->(slug) {
    event_contribution_type = EventContributionType.find_by(slug: slug.to_s.downcase)

    if event_contribution_type
      joins(:event_contribution_type).where(event_contribution_types: { id: event_contribution_type })
    elsif slug.to_s.casecmp('free').zero?
      where.not(id: joins(:event_contribution_detail))
    else
      all
    end
  }

  scope :with_group, -> {
    joins(:user).where(users: { user_type: User.user_types[:business] })
  }

  scope :with_personal, -> {
    joins(:user).where(users: { user_type: User.user_types[:personal] })
  }

  scope :ordered_by_name, -> {
    reorder('title ASC')
  }

  scope :ordered_by_popular, -> {
    joins('LEFT OUTER JOIN event_attendees ON event_attendees.event_id = events.id')
      .select('events.*, coalesce(COUNT(DISTINCT event_attendees.id), 0) as attendees_count')
      .group('events.id')
      .reorder('attendees_count DESC')
  }

  scope :with_contributions, -> {
    where(id: joins('LEFT OUTER JOIN event_contribution_details ON event_contribution_details.event_id = events.id')
                  .having('COALESCE(COUNT(DISTINCT event_contribution_details.id)) > 0')
                  .group('events.id'))
  }

  scope :without_contributions, -> {
    where.not(id: with_contributions.pluck(:id))
  }

  scope :with_tickets, -> {
    where(id:  joins('LEFT OUTER JOIN event_ticket_details ON event_ticket_details.event_id = events.id')
                  .having('COALESCE(COUNT(DISTINCT event_ticket_details.id)) > 0')
                  .group('events.id'))
  }

  scope :without_tickets, -> {
    where.not(id: with_tickets.pluck(:id))
  }

  scope :ordered_by_reports, -> {
    joins('LEFT OUTER JOIN reports ON reports.reportable_id = events.id')
        .select('events.*, coalesce(COUNT(DISTINCT reports.id), 0) as reports_count')
        .group('events.id')
        .reorder('reports_count DESC')
  }

  # media
  def media_item
    event_media_items.first
  end

  # related events
  def related_events
    Event.active.where(id: TaggedObject.where(tag_id: tags.pluck(:id)).uniq.pluck(:taggable_id)).where.not(id: id).not_private.order_to_now.limit(5)
  end

  def public_address
    display_address || address
  end

  def private_address
    public_address
  end

  reverse_geocoded_by :latitude, :longitude do |obj, results|
    if geo = results.first
      obj.city = geo.city
      obj.state = geo.state
      obj.postal_code = geo.postal_code
      obj.address = geo.address
      obj.country = geo.country
      obj.country_code = obj.sanitized_country_code(geo)
    end
  end
  before_validation :reverse_geocode

  def location
    { latitude: latitude, longitude: longitude, radius: Api::Search::Events::DEFAULT_RADIUS }
  end

  def geometry
    center_point = [latitude, longitude]
    units = :km

    # offset to a random point near original point
    random_point = Geocoder::Calculations.random_point_near(center_point, Api::Search::Events::RANDOM_OFFSET_DISTANCE, units: units)
    box = Geocoder::Calculations.bounding_box(random_point, Api::Search::Events::DEFAULT_GEOMETRY_DISTANCE, units: units)

    {
        bounds: {
            southwest: { latitude: box[0], longitude: box[1] },
            northeast: { latitude: box[2], longitude: box[3] }
        },
        radius: Api::Search::Events::DEFAULT_RADIUS
    }
  end

  # Attendees
  def mutual_event_attendees(user)
    return User.none if user.blank?

    user.friends.where(id: event_attendees.going.joins(:user).pluck('users.id'))
  end

  # Caching and Reporting
  after_save :update_caches
  before_destroy :update_caches
  after_destroy :update_caches
  after_report :deactivate_if_report_threshold_breached

  # Report Threshold
  def self.report_threshold
    ENV.fetch('EVENT_REPORT_THRESHOLD', 100).to_i
  end

  # Country Codes
  def sanitized_country_code(geo)
    if geo.country_code == 'GB'
      united_kingdom_country_code_mappings[geo.state_code&.to_sym]
    else
      geo.country_code
    end
  end

  def united_kingdom_country_code_mappings
    {
      'Northern Ireland': 'GB-NIR',
      'Scotland': 'GB',
      'Wales': 'GB',
      'England': 'GB'
    }
  end

  # Conversations

  def create_conversation_if_required
    # create chat if required
    create_event_conversation if allow_chat
  end

  def create_event_conversation
    conversation_service.create_or_update_conversation_without_message(event_ownerable, conversation_params, self)
  end

  def deactivate_conversation!
    return true if conversation.blank?
    conversation.update_attributes(activated: false)
  end

  def conversation_service
    @conversation_service ||= ::Conversations::ConversationsService.new
  end

  def conversation_params
    participants = []
    attending_users.each do |user|
      participants << { id: user.id, type: user.class.to_s }
    end

    {
      meta_data: {
        name: title
      },
      participants: participants
    }
  end

  def business_event
    self.event_ownerable_type == 'Company'
  end

  # status helpers
  def status
    return :deactivated unless active
    return :active if active
  end

  def status_class
    case status.to_sym
    when :deactivated
      'danger'
    when :active
      'success'
    end
  end

  def active?
    active
  end

  def branch_link
    require 'net/http'
    require 'uri'
    require 'json'

    uri = URI.parse('https://api.branch.io/v1/url')
    request = Net::HTTP::Post.new(uri)
    request.body = JSON.dump(
      branch_key: ENV['BRANCH_KEY'],
      data: {
        "$canonical_identifier": Time.now.to_i,
        "$og_title": title,
        "$og_description": description,
        "$og_image_url": media_item&.sharing_url,
        "$desktop_url": 'http://mygo.io',
        event_id: id.to_s
      }
    )

    req_options = {
      use_ssl: uri.scheme == 'https'
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    if response.code.to_i == 200
      response_body = JSON.parse(response.body)
      response_body.with_indifferent_access[:url]
    else
      ENV['BRANCH_URL']
    end
  end

  def cache_key(type = :feed)
    key = "event_#{id}_"
    key = "_#{type}_#{key}_" unless type.nil?

    key
  end

  def cache_serializer(_type = :feed)
    ::Events::OverviewSerializer
  end

  def cached(cache_event_owner = nil, type: :feed)
    key = "user_#{cache_event_owner&.id}_#{cache_key(type)}"

    cached_event = cached_object key do
      cached_event = cached_object cache_key(type) do
        serialized_resource(self, cache_serializer(type), user: nil)
      end

      additional_cache_information(cached_event, cache_event_owner, type: type)
    end

    cached_event
  end

  def additional_cache_information(cached_event, cache_event_owner = nil, type: :feed)
    if type.eql?(:overview)
      # if cache_user&.eql?(user)
      #   cached_event[:attendee_count] = event_attendees.valid.count
      #   cached_event[:attendees] = serialized_resource(event_attendees.valid.joins(:user).where.not(user: cache_user).order("users.business_name ASC, users.first_name || ' ' || users.last_name ASC").limit(10), ::Events::Attendees::OverviewSerializer, exclude_user: false, user: cache_user)
      # end

      cached_event[:country] = serialized_resource(country_object, ::Countries::OverviewSerializer)
      cached_event[:currency] = serialized_resource(currency, ::Countries::Currencies::OverviewSerializer)
      cached_event[:event_contribution_detail] = serialized_resource(event_contribution_detail, ::Events::Contributions::Details::OverviewSerializer) if event_contribution_detail&.active
      cached_event[:event_ticket_detail] = serialized_resource(event_ticket_detail, ::Events::Tickets::Details::OverviewSerializer) if event_ticket_detail&.active
    end

    # unless cache_event_owner.nil?
    #   cached_event[:mutual_attendee_count] = mutual_event_attendees(cache_user).count
    #   cached_event[:mutual_attendees] = mutual_event_attendees(cache_user).limit(2).map { |user| user.cached(cache_user, type: :feed) }
    #   cached_event[:reported] = Report.exists?(reporter: cache_user, reportable: self)
    #   cached_event[:attendance] = serialized_resource(event_attendees.where(user: cache_user).first, ::Events::Attendees::OverviewSerializer, exclude_user: true, user: cache_user)
    # end

    cached_event
  end

  def update_caches
    event_ownerable&.update_caches
    remove_cached_object(cache_key(nil))

    %i[feed overview].each do |type|
      cached(type: type)
    end
  end

  def user_from_event_owner
    case event_ownerable_type
    when 'User'
      event_ownerable
    when 'Company'
      event_ownerable.user
    when 'Group'
      event_ownerable.owner
    end
  end

  def init_chat
    chat = ChatkitService.new(user_from_event_owner, {name: title}).create_room
    create_chat(chatkit_id: chat[:body][:id]) if chat[:status] == 201
  end

  private

  def ensure_date_time
    self.date_time = Time.at(date.beginning_of_day.to_i + (time.to_i - time.beginning_of_day.to_i)).utc
  end

  def create_event_cancelled_notifier_if_necessary
    create_event_cancelled_notifier if active_changed? && !active? && !event_cancelled_notifier && date > Time.now
  end

  # Reports
  def deactivate_if_report_threshold_breached
    update_attributes(active: false, inactive_at: Time.now) if reports.unconsidered.count >= Event.report_threshold
  end
end

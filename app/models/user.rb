class User < ActiveRecord::Base
  devise :database_authenticatable, :async, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  include Indestructable
  include Showoff::Concerns::Imagable
  include Reportable
  include CoverImageable

  include Showoff::SNS::Notifiable

  include Showoff::Payments::CustomerVendors::CustomerVendorable
  include Showoff::Helpers::SerializationHelper

  include Api::ErrorHelper
  include Api::CacheHelper

  include Feeds::Feedable
  include Users::Filterable

  include Conversations::Conversationable
  include Currencyable

  enum user_type: [:personal, :business]
  enum account_type: %i[individual company]

  belongs_to :user_age_range

  has_one :user_business
  has_one :user_notification_setting
  has_one :facebook_friend_notifier, class_name: '::Showoff::Notifiers::FacebookFriendNotifier', as: :owner, dependent: :destroy

  has_many :owned_conversations, class_name: 'Conversations::Conversation', as: :owner
  has_many :phone_numbers, class_name: 'UserPhoneNumber'
  has_many :user_logins

  has_many :tagged_objects, -> {order(:created_at)}, as: :owner, dependent: :destroy
  has_many :object_tags, through: :tagged_objects, source: :tag

  has_many :friend_requests, dependent: :destroy
  has_many :pending_friend_requests, class_name: 'FriendRequest', foreign_key: :friend_id, dependent: :destroy
  has_many :pending_friends, through: :friend_requests, source: :friend

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  has_many :by_mentioned_users, -> {order(created_at: :desc)}, class_name: 'MentionedUser', foreign_key: :mentioned_user_id, dependent: :destroy
  has_many :by_mentioning_users, -> {order(created_at: :desc)}, class_name: 'MentionedUser', foreign_key: :owner_id, dependent: :destroy

  has_many :mentioned_by_users, through: :by_mentioned_users, source: :user
  has_many :mentioned_users, through: :by_mentioning_users, source: :mentioned_user

  has_many :identifications, dependent: :destroy
  has_many :addresses
  has_many :notification_setting_user_notification_settings, through: :user_notification_setting

  has_many :reported_objects, class_name: 'Report', as: :reporter, dependent: :destroy
  has_many :reported_by, class_name: 'Report', as: :reportable, dependent: :destroy
  has_many :reported_events, through: :reported_objects, source: :reportable, source_type: Event
  has_many :reported_users, through: :reported_objects, source: :reportable, source_type: User
  has_many :reported_event_timeline_items, through: :reported_objects, source: :reportable, source_type: EventTimelineItem
  has_many :reported_event_timeline_item_comments, through: :reported_objects, source: :reportable, source_type: EventTimelineItemComment

  has_many :user_tags, dependent: :destroy
  has_many :tags, through: :user_tags

  has_many :events, as: :event_ownerable
  has_many :hosting_events, class_name: 'Event', as: :event_ownerable

  has_many :event_attendees
  has_many :attending_events, -> {where(event_attendees: {status: EventAttendee.statuses[:going]})}, through: :event_attendees, source: :event
  has_many :maybe_attending_events, -> {where(event_attendees: {status: EventAttendee.statuses[:maybe_going]})}, through: :event_attendees, source: :event
  has_many :not_attending_events, -> {where(event_attendees: {status: EventAttendee.statuses[:not_going]})}, through: :event_attendees, source: :event
  has_many :invited_events, -> {where(event_attendees: {status: EventAttendee.statuses[:invited]})}, through: :event_attendees, source: :event
  has_many :possible_attending_events, through: :event_attendees, source: :event
  has_many :potentially_attending_events, -> {where(event_attendees: {status: [EventAttendee.statuses[:going], EventAttendee.statuses[:maybe_going]]})}, through: :event_attendees, source: :event

  has_many :event_timeline_items, dependent: :destroy

  has_many :event_shares
  has_many :shared_events, through: :event_shares, source: :event
  has_many :event_share_users
  has_many :shared_with_events, through: :event_share_users, source: :event

  has_many :event_timeline_item_likes, -> {order(updated_at: :desc)}, dependent: :destroy
  has_many :liked_event_timeline_items, through: :event_timeline_item_likes, source: :event_timeline_item
  has_many :liked_events, through: :liked_event_timeline_items, source: :event

  has_many :event_timeline_item_comments, dependent: :destroy
  has_many :commented_event_timeline_items, -> {uniq!}, through: :event_timeline_item_comments, source: :event_timeline_item
  has_many :commented_events, through: :commented_event_timeline_items, source: :event

  has_many :user_facebook_event_imports, dependent: :destroy
  has_many :friend_events, through: :friends, class_name: 'Event', source: :events

  has_many :companies

  with_options class_name: 'Membership', inverse_of: :user, dependent: :destroy do
    has_many :memberships
    has_many :approved_memberships, -> { active }
    has_many :unapproved_memberships, -> { inactive }
  end
  has_many :groups, through: :memberships, source: :group

  has_many :owned_groups, class_name: 'Group', inverse_of: :owner, dependent: :destroy
  has_many :liked_offers, dependent: :destroy
  has_many :liked_special_offers, class_name: 'SpecialOffer', through: :liked_offers, source: :special_offer

  after_create :subscribe_to_mailing_list
  after_create :ensure_user_notification_setting

  after_update :update_vendor_data_if_required
  after_update :update_on_mailing_list

  before_save :set_age_range
  after_save :update_caches

  after_destroy :update_caches

  after_report :deactivate_if_report_threshold_breached

  with_options unless: :user_name? do |user|
    user.validates :first_name, :last_name, presence: true
    user.validates :first_name, :last_name, length: { minimum: 1 }
  end

  with_options unless: Proc.new { |u| u.first_name? || u.last_name? } do |user|
    user.validates :user_name, presence: true
    user.validates :user_name, length: { minimum: 1 }
  end

  scope :today, -> {
    where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
  }

  scope :ordered_by_name, -> {
    reorder("users.business_name ASC, users.first_name || ' ' || users.last_name ASC")
  }

  scope :ordered_by_number_attending, -> {
    joins('LEFT OUTER JOIN event_attendees ON event_attendees.user_id = users.id')
    .where(event_attendees: {status: EventAttendee.statuses[:maybe_going]})
        .select('users.*, coalesce(COUNT(DISTINCT event_attendees.id), 0) as attending_count')
        .group('users.id')
        .reorder('attending_count DESC')
  }

  scope :ordered_by_number_hosting, -> {
    joins('LEFT OUTER JOIN events ON events.user_id = users.id')
        .select('users.*, coalesce(COUNT(DISTINCT events.id), 0) as hosting_count')
        .group('users.id')
        .reorder('hosting_count DESC')
  }

  scope :ordered_by_reports, -> {
    joins('LEFT OUTER JOIN reports ON reports.reportable_id = users.id')
        .select('users.*, coalesce(COUNT(DISTINCT reports.id), 0) as reports_count')
        .group('users.id')
        .reorder('reports_count DESC')
  }

  scope :joined_after, ->(date) {where(arel_table[:created_at].gteq(Date.strptime(date, '%d/%m/%Y')))}
  scope :active, -> {where(active: true, suspended: false)}
  scope :inactive, -> {where(arel_table[:active].eq(false).or(arel_table[:suspended].eq(true)))}

  scope :male, -> {where(gender: 'male')}
  scope :female, -> {where(gender: 'female')}
  scope :unspecified, -> {where(gender: nil)}

  scope :for_term, ->(text) {where("first_name || ' ' || last_name ILIKE ? OR business_name ILIKE ?", "%#{text}%", "%#{text}%")}

  scope :hosting_facebook_events, -> {
    joins(:events).where.not(events: {facebook_id: nil})
  }

  def unliked_active_offers
    SpecialOffer.active.where.not(id: liked_special_offers.ids)
  end

  def user_feed_items_for_friend(friend_id)
    user_feed_items.joins(:feed_item_context).joins(:actor).where(feed_item_contexts: {actor_id: friend_id})
  end

  def mutual_friends(user)
    return User.none if user.blank?
    friends.where(id: user.friends.pluck(:id))
  end

  def mutual_friends_for_events(events)
    return User.none if events.blank?

    User.where(id: friends.map(&:id)).where(id: EventAttendee.where(event: Event.where(id: events.map(&:id)).active, status: EventAttendee.statuses[:going]).map(&:user_id))
  end

  def mutual_events(events)
    return Event.none if events.blank?

    event_ids = Event.where(id: events.map(&:id))
                     .active
                     .joins(:event_attendees)
                     .where(event_attendees: { user_id: friends, status: EventAttendee.statuses[:going] }).map(&:id)

    Event.active.where(id: event_ids)
  end

  def applicable_events
    all_events = Event.not_private.where.not(event_ownerable_type: 'Company').or(Event.where(event_ownerable_type: 'Company').approved)
    all_events = Event.where(id: all_events + hosting_events + friend_events.not_private + attending_events + maybe_attending_events + invited_events + shared_with_events).active.order(created_at: :desc)
    all_events = all_events.not_eighteen_plus unless self.eighteen_plus
    all_events
  end

  def name
    if business? && business_name
      business_name
    else
      user_name ? user_name : [first_name, last_name].join(' ')
    end
  end

  # passwords
  def password_required?
    (facebook_access_token.blank? || facebook_uid.blank?) && encrypted_password.blank?
  end

  def password_match?
    if password_required?
      errors[:password] << "can't be blank" if password.blank?
      errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
      errors[:password_confirmation] << 'does not match password' if password != password_confirmation
      password == password_confirmation && !password.blank?
    else
      true
    end
  end

  # age
  def age
    dob = date_of_birth
    return 0 if dob.blank?

    now = Time.now.utc.to_date
    now.year - dob.year - (now.month > dob.month || (now.month == dob.month && now.day >= dob.day) ? 0 : 1)
  end

  # identification
  def identification
    identifications.first
  end

  def buyer_validation_required?
    (identifications.pending_verification_or_verified.count == 0 || gender.blank? || date_of_birth.blank? || !confirmed? || phone_number.blank? || !image.file?)
  end

  def seller_validation_required?
    (
    country_code.blank? ||
        account_type.blank?
    )
  end

  def phone_number_present?
    return false if current_address.blank?
    current_address.phone_number.present?
  end

  def verified?
    country_code.present? && account_type.present? && date_of_birth.present? &&
        gender.present? && confirmed? && phone_number_present? &&
        identifications.pending_verification_or_verified.count != 0 &&
        current_address.present? && has_bank_account
  end

  def business_details_required?
    company? && user_business.blank?
  end

  # facebook
  def merge_facebook_for_user(uid, access_token)
    graph = Koala::Facebook::API.new(access_token)
    profile = graph.get_object('me')

    if profile['id'].to_i.eql?(uid.to_i)
      self.facebook_uid = uid
      self.facebook_access_token = access_token
      save
      return true
    end
    false
  rescue Koala::Facebook::AuthenticationError
    false
  end

  # facebook events
  def import_facebook_events(access_token)
    user_facebook_event_imports.create(access_token: access_token)
  end

  # terms of service
  def tos_ip
    tos_ip = '127.0.0.1'
    if tos_acceptance_ip.present?
      tos_ip = tos_acceptance_ip
    else
      ip = Socket.ip_address_list.detect(&:ipv4_private?)
      tos_ip = ip.ip_address if ip
    end
    tos_ip
  end

  def tos_timestamp
    tos_timestamp = Time.zone.now.to_i
    if tos_acceptance_timestamp.present?
      tos_timestamp = tos_acceptance_timestamp.to_i
    end
    tos_timestamp
  end

  # vendorable
  def vendor_data
    params = {
        country: country_code,
        email: email,
        tos_acceptance: {
            ip: tos_ip,
            date: tos_timestamp
        },
        payout_schedule: {
            delay_days: 7,
            interval: 'daily'
        }
    }

    params[:legal_entity] = {}
    params[:legal_entity][:first_name] = first_name if first_name.present?
    params[:legal_entity][:last_name] = last_name if last_name.present?

    if date_of_birth.present?
      params[:legal_entity][:dob] = {
          day: date_of_birth.day,
          month: date_of_birth.month,
          year: date_of_birth.year
      }
    end

    if individual?
      params[:legal_entity][:type] = 'individual'
      params[:legal_entity][:address] = address_hash(current_address) if current_address.present?
    elsif company?
      params[:legal_entity][:type] = 'company'
      params[:legal_entity][:business_name] = user_business.name if user_business.present?
      params[:legal_entity][:business_tax_id] = user_business.tax_id if user_business.present?
      params[:legal_entity][:address] = address_hash(user_business) if user_business.present?
      params[:legal_entity][:personal_address] = address_hash(current_address) if current_address.present?

      # NOTE: This may need to be updated to allow for additional owners
      params[:legal_entity][:additional_owners] = nil
    end

    params
  end

  # business details
  def business_details=(params)
    create_user_business(params) if user_business.blank?
    user_business.update_attributes(params) if user_business.present?
  end

  # current address
  def current_address
    address = addresses.active.first
    return address if address.present?
    addresses.active.first if address.blank?
  end

  # country
  def country
    @country ||= ISO3166::Country.find_country_by_alpha2(country_code)
  end

  # status helpers
  def status
    return :suspended if suspended
    return :deactivated unless active
    :active if active
  end

  def status_class
    case status.to_sym
    when :deactivated || :suspended
      'danger'
    when :active
      'success'
    end
  end

  def active?
    active
  end

  # deactivation
  def can_deactivate?
    true
  end

  def revoke_all_sessions!
    Doorkeeper::AccessToken.where(resource_owner_id: id, revoked_at: nil).each(&:revoke)
    user_logins.each(&:revoke!)
    true
  rescue StandardError => e
    report_error(e)
    false
  end

  # Events
  def deactivate_all_events!
    events.all.each(&:deactivate!)
    true
  rescue StandardError => e
    report_error(e)
    false
  end

  def activate_all_events!
    events.all.each(&:activate!)
    true
  rescue StandardError => e
    report_error(e)
    false
  end


  # Friends
  def remove_friend(friend)
    friends.destroy(friend)
  end

  # counts
  def notification_count
    sent_notifications.where.not(notifier_type: 'Conversations::MessageSentNotifier').count
  end

  # mailing lists
  def subscribe_to_mailing_list
    mail_listing_subscribe(send_welcome: false, update_data: true)
  end

  def update_on_mailing_list
    mail_listing_subscribe(send_welcome: false, update_data: true)
  end

  def mail_listing_subscribe(send_welcome:, update_data:)
    mailchimp = Mailchimp::API.new(ENV['MAILCHIMP_API_KEY'])
    mailchimp.lists.subscribe(ENV['MAILCHIMP_LIST_ID'],
                              {email: email},
                              {
                                  FIRST_NAME: first_name.present? ? first_name : '',
                                  LAST_NAME: last_name.present? ? last_name : '',
                                  AGE: age,
                                  CONFIRMED: confirmed? ? 1 : 0,
                                  GENDER: gender,
                                  VERIFIED: verified? ? 1 : 0,
                              },
                              'html',
                              false,
                              update_data,
                              false,
                              send_welcome)
  rescue StandardError => e
    report_error(e)
  end

  # notifications
  def notify_facebook_friends
    facebook_username = "#{first_name} #{last_name}".strip
    create_facebook_friend_notifier(facebook_username: facebook_username) unless facebook_username.blank? || facebook_uid.nil? || facebook_access_token.nil?
  end

  # Feeds
  def actor_serializer
    ::Users::Feed::OverviewSerializer
  end

  # Notification Settings
  def ensure_user_notification_setting
    create_user_notification_setting if user_notification_setting.blank?
    user_notification_setting.update_attributes(updated_at: Time.now)
  end

  def notifications_enabled_for(slug)
    ensure_user_notification_setting

    notification_setting = NotificationSetting.find_by(slug: slug)
    setting = user_notification_setting.notification_setting_user_notification_settings.find_by(notification_setting: notification_setting)
    setting.present? ? setting.enabled : false
  end

  def cache_key(type = :feed)
    key = "user_#{id}_"
    key = "_#{type}_#{key}_" unless type.nil?

    key
  end

  def cache_serializer(type = :feed)
    case type
    when :feed
      ::Users::Feed::OverviewSerializer
    when :private
      ::Users::PrivateSerializer
    else
      ::Users::PublicSerializer
    end
  end

  def cached(user = nil, type: :feed, event: nil)
    key = "user_#{user&.id}_#{cache_key(type)}"

    cached_user = cached_object key do
      cached_user = cached_object cache_key(type) do
        serialized_resource(self, cache_serializer(type), user: self)
      end

      additional_cache_information(cached_user, user, type: type)
    end

    cached_user[:shared] = event&.shared_with_users&.include?(self) || false
    cached_user[:invited] = event&.event_attendees&.find_by(user: self)&.invited || (event.present? && contact_service.invited?(nil, user, event, id)) || false

    cached_user
  end

  def additional_cache_information(cached_user, user = nil, type: :feed)
    if %i[public private].include?(type)
      cached_user[:friend_count] = friends.count
      cached_user[:attending_event_count] = attending_events.where.not(event_ownerable: self).starting_at_or_after(Time.now).active.count
      cached_user[:event_count] = hosting_events.starting_at_or_after(Time.now).active.count
      cached_user[:mutual_friends_count] = mutual_friends(user).count if user
    end

    friend_request_pending = pending_friend_requests.where(user: user).count.positive?

    cached_user[:friend_request_pending] = friend_request_pending
    cached_user[:pending_friend_request] = friend_request_pending ? { id: pending_friend_requests.order(created_at: :desc).find_by(user: user).id } : nil
    cached_user[:friend] = friends.include?(user) || false

    cached_user
  end

  def update_caches
    remove_cached_object(cache_key(nil))

    %i[feed public private].each do |type|
      cached(self, type: type)
    end
  end

  private

  def contact_service
    @contact_service ||= Showoff::Services::ContactService.new
  end

  def self.report_threshold
    ENV.fetch('USER_REPORT_THRESHOLD', 100).to_i
  end

  def deactivate_if_report_threshold_breached
    update_attributes(suspended: true, suspended_at: Time.now) if reports.unconsidered.count >= User.report_threshold
  end

  def update_vendor_data_if_required
    Showoff::Payments::VendorWorker.perform_async(id, self.class.to_s)
  end

  def address_hash(address)
    address_hash = {}
    address_hash[:line1] = address.line1 if address.line1.present?
    address_hash[:line2] = address.line2 if address.line2.present?
    address_hash[:city] = address.city if address.city.present?
    address_hash[:state] = address.state if address.state.present?
    address_hash[:postal_code] = address.postal_code if address.postal_code.present?
    address_hash[:country] = address.country_code.upcase if address.country_code.present?
    address_hash
  end

  def set_age_range
    self.user_age_range = UserAgeRange.where('start_age <= ? AND end_age > ?', age, age).first
  end
end

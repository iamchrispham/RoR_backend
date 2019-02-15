# frozen_string_literal: true

class Group < ActiveRecord::Base
  include Showoff::Concerns::Imagable
  include Indestructable
  include Taggable
  include Currencyable

  with_options dependent: :destroy do
    has_many :contacts, as: :contactable
    has_many :posts, -> { order(id: :desc) }, as: :postable
    has_many :liked_offers

    with_options class_name: 'OfferApproval', inverse_of: :group do
      has_many :offer_approvals
      has_many :approved_offers, -> { active }
      has_many :unapproved_offers, -> { inactive }
    end

    with_options class_name: 'Membership', inverse_of: :group do
      has_many :memberships
      has_many :approved_memberships, -> { active }
      has_many :unapproved_memberships, -> { inactive }
    end

    with_options class_name: 'SubgroupEventsApproval', inverse_of: :subgroup do
      has_many :subgroup_events_approvals
      has_many :subgroup_events_approved, -> { active }
      has_many :subgroup_events_pending, -> { inactive }
    end
  end

  with_options through: :approved_memberships, source: :user do
    has_many :approved_active_members, -> { active }
  end

  with_options through: :unapproved_memberships, source: :user do
    has_many :unapproved_active_members, -> { active }
  end

  with_options through: :approved_offers, source: :special_offer do
    has_many :approved_active_offers, -> { active }
    has_many :approved_past_active_offers, -> { active.past }
  end

  has_many :unapproved_active_offers,
           -> { where(offer_approvals: { active: false }).active },
           through: :offer_approvals,
           source: :special_offer

  has_many :group_subgroup_approvals, dependent: :destroy
  has_many :group_invitations, dependent: :destroy

  with_options source: :subgroup do
    has_many :approved_subgroups,
             -> { where(group_subgroup_approvals: { active: true }) },
             through: :group_subgroup_approvals
    has_many :pending_subgroups,
             -> { where(group_subgroup_approvals: { active: false }) },
             through: :group_subgroup_approvals
  end

  # use only for quickly lookup subgroups
  with_options class_name: 'Group' do
    has_many :subgroups, foreign_key: :parent_id, dependent: :nullify, inverse_of: :parent
    belongs_to :parent
  end

  with_options through: :memberships, source: :user do
    has_many :active_members, -> { active }
    has_many :active_friends, -> { joins(:friendships).active }
  end

  has_many :events, as: :event_ownerable
  has_many :tagged_groups, -> { uniq! }, through: :tagged_objects, source: :taggable, source_type: Group

  taggable_attributes :group_tags
  taggable_owner :owner

  has_many :liked_special_offers,
           through: :liked_offers,
           source: :special_offer

  belongs_to :owner, class_name: 'User', foreign_key: :user_id, inverse_of: :owned_groups

  validates :name,
            presence: true,
            uniqueness: true

  validates :phone,
            format: { with: General::PHONE_FORMAT_REGEXP },
            length: { minimum: 7, maximum: 13 },
            allow_blank: true

  validates :facebook_profile_link,
            :linkedin_profile_link,
            :instagram_profile_link,
            :snapchat_profile_link,
            :website,
            url: { allow_blank: true }

  validates_with EmailAddress::ActiveRecordValidator,
                 field: :details

  validates :email_domain,
            presence: true,
            if: ->(group) { group.college? }

  enum category: {
    college: 'college',
    normal: 'normal',
    society: 'society',
    meetup: 'meetup'
  }

  enum acceptance_mode: {
    automatic: 'automatic',
    manual: 'manual'
  }

  enum accessibility: {
    publicly_accessible: 'publicly_accessible',
    privately_accessible: 'privately_accessible'
  }

  scope :colleges, -> { where(category: :college) }
  scope :active, -> { where(active: true) }
  scope :search_by_name, ->(text) { where("name ILIKE ?", "%#{text}%") }

  def subgroups_events
    Event
      .where("event_ownerable_id in (select id from groups where parent_id = #{id} and active is true)")
      .where(event_ownerable_type: 'Group')
  end

  def subgroups_events_approved
    subgroups_events.joins(:subgroup_events_approved)
  end

  def subgroups_events_pending
    subgroups_events.joins(:subgroup_events_pending)
  end

  def status
    active ? :active : :deactivated
  end

  def status_class
    case status
    when :deactivated
      'danger'
    when :active
      'success'
    else
      'warning'
    end
  end

  def update_caches; end

  def cached(_, _); end
end

# frozen_string_literal: true

class Group < ActiveRecord::Base
  include Showoff::Concerns::Imagable
  include Indestructable

  with_options dependent: :destroy do
    has_many :events, as: :event_ownerable
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

  with_options class_name: 'Group' do
    has_many :subgroups, foreign_key: :parent_id, dependent: :nullify, inverse_of: :parent
    belongs_to :parent
  end

  with_options through: :memberships, source: :user do
    has_many :active_members, -> { active }
    has_many :active_friends, -> { joins(:friendships).active }
  end

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

  scope :colleges, -> { where(category: :college) }

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

  def college?
    category == 'college'
  end
end

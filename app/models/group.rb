# frozen_string_literal: true

class Group < ActiveRecord::Base
  include Showoff::Concerns::Imagable
  include Indestructable

  with_options dependent: :destroy do
    has_many :contacts, as: :contactable
    has_many :posts, as: :postable
    has_many :memberships
    has_many :approved_offers
  end

  with_options class_name: 'Group' do
    has_many :subgroups, foreign_key: :parent_id, dependent: :nullify, inverse_of: :parent
    belongs_to :parent
  end

  with_options through: :memberships, source: :user do
    has_many :active_members, -> { active }
    has_many :active_friends, -> { joins(:friendships).active }
  end

  with_options through: :approved_offers, source: :special_offer do
    has_many :approved_active_offers, -> { active }
    has_many :approved_past_active_offers, -> { active.past }
  end

  belongs_to :owner, class_name: 'User', foreign_key: :user_id, inverse_of: :owned_groups

  validates :name,
            presence: true,
            uniqueness: true

  enum category: {
    college: 'college',
    normal: 'normal',
    society: 'society',
    meetup: 'meetup'
  }

  def unapproved_active_offers
    SpecialOffer.active.where.not(id: approved_active_offers.ids)
  end
end

# frozen_string_literal: true

class SpecialOffer < ActiveRecord::Base
  include Showoff::Concerns::Imagable
  include Indestructable

  with_options dependent: :destroy, inverse_of: :special_offer do
    has_many :liked_offers
    with_options class_name: 'OfferApproval' do
      has_many :approved_offers, -> { active }
      has_many :unapproved_offers, -> { inactive }
    end
  end

  validates :title, presence: true, uniqueness: true

  validate :start_end_timestamps
  validate :publish_end_timestamps

  scope :past, -> { where('now() > ends_at') }

  private

  def start_end_timestamps
    return if starts_at.blank? || ends_at.blank?
    return if starts_at < ends_at

    errors.add(:starts_at, 'should be less then special offer\'s end timestamp')
  end

  def publish_end_timestamps
    return if publish_on.blank? || ends_at.blank?
    return if publish_on < ends_at

    errors.add(:publish_on, 'should be less then special offer\'s end timestamp')
  end
end

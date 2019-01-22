# frozen_string_literal: true

class LikedOffer < ActiveRecord::Base
  belongs_to :user
  belongs_to :special_offer
  belongs_to :group

  validates :special_offer_id, :group_id, :user_id, presence: true

  validates :special_offer_id,
            uniqueness: {
              scope: %i[group_id user_id],
              message: 'already liked'
            }
end

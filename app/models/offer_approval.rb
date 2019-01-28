# frozen_string_literal: true

class OfferApproval < ActiveRecord::Base
  include Indestructable

  belongs_to :user
  belongs_to :special_offer
  belongs_to :group

  validates :special_offer_id, :group_id, :user_id, presence: true

  validates :special_offer_id,
            uniqueness: {
              scope: :group_id,
              message: 'already approved'
            }

  def status
    active ? :approved : :unapproved
  end

  def status_class
    case status
    when :unapproved
      'warning'
    when :approved
      'success'
    else
      'danger'
    end
  end
end

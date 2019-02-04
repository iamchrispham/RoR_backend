# frozen_string_literal: true

class Membership < ActiveRecord::Base
  include Indestructable

  belongs_to :user
  belongs_to :group

  validates :user_id,
            uniqueness: {
              scope: %i[group_id],
              message: 'has group membership'
            }

  def status
    return :active if active

    :pending
  end
end

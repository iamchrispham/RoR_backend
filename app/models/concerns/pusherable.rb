module Pusherable
 extend ActiveSupport::Concern

  included do
    after_validation :create_pusher_user, on: :create, unless: -> { pusher_id.present? }
    after_destroy :delete_pusher_user, if: -> { pusher_id.present? }
  end

  # private

  def create_pusher_user
    self.pusher_id = generated_pusher_id
    self.save
    ChatkitService.new(self).create_user
  end

  def delete_pusher_user
    ChatkitService.new(self.id).delete_user
  end

  def generated_pusher_id
    SecureRandom.uuid
  end
end

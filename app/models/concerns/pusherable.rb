module Pusherable
  extend ActiveSupport::Concern

  included do
    after_create :create_pusher_user, unless: -> { pusher_id.present? }
    after_destroy :delete_pusher_user, if: -> { pusher_id.present? }
  end

  private

  def create_pusher_user
    ChatkitService.new(self.id).create_user(self.name)
    self.update(pusher_id: self.id.to_s)
  end

  def delete_pusher_user
    ChatkitService.new(self.id).delete_user
  end
end

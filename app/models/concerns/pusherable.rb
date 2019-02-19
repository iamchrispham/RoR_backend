module Pusherable
  extend ActiveSupport::Concern

  included do
    after_create :create_pusher_user, unless: -> { pusher_id.present? }
    after_destroy :delete_pusher_user, if: -> { pusher_id.present? }
  end

  private

  def create_pusher_user
    ChatkitService.new.create_user(self)
    self.update(pusher_id: self.id.to_s)
  end

  def delete_pusher_user
    ChatkitService.new.delete_user(self)
  end
end

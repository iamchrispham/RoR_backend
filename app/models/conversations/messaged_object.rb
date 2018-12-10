module Conversations
  class MessagedObject < ActiveRecord::Base
    belongs_to :recipient, polymorphic: true
    belongs_to :message, class_name: 'Conversations::Message'

    enum status: [:pending, :sending, :sent, :delivered, :read, :failed]

    before_create :set_pending

    private
    def set_pending
      self.status = :pending
      return true
    end

  end
end

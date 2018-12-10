module Conversations
  class MessageAttachment < ActiveRecord::Base
    belongs_to :message
    belongs_to :attachment, polymorphic: true, dependent: :destroy
    validates :attachment, presence: true
  end
end

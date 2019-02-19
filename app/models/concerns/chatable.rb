module Chatable
  extend ActiveSupport::Concern

  included do
    has_many :chats, as: :chatable, dependent: :destroy
  end
end

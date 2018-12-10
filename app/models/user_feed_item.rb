class UserFeedItem < ActiveRecord::Base
  belongs_to :feed_item
  belongs_to :user

  has_one :feed_item_context, through: :feed_item
  has_one :actor, through: :feed_item_context, source_type: 'User'

  validates :feed_item, :user, presence: true

  after_save :update_caches
  after_destroy :update_caches

  def update_caches
    user&.update_caches
  end
end

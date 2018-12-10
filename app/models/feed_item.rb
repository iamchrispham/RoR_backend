class FeedItem < ActiveRecord::Base
  include Indestructable

  belongs_to :object, polymorphic: true

  belongs_to :feed_item_context, dependent: :destroy
  has_many :user_feed_items, dependent: :destroy
  has_many :users, through: :user_feed_items

  validates :feed_item_context, :object, presence: true
  validate :validate_users

  after_save :update_caches
  after_destroy :update_caches

  def update_caches
    user&.update_caches
    users.map(&:update_cache)
  end

  def validate_users
    errors.add(:users, 'must have at least one user for a feed item') if self.users.size.zero?
  end

  def type
    object_type.underscore
  end

  def media
    return object if object.is_a? EventTimelineItem
  end

  def event
    return object if object.is_a? Event
  end

  def context
    feed_item_context
  end
end

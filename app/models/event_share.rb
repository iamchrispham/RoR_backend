class EventShare < ActiveRecord::Base
  include Feeds::FeedActionable
  include Indestructable

  belongs_to :user
  belongs_to :event

  has_many :event_share_users
  has_many :users, through: :event_share_users, source: :user

  has_one :event_share_notifier, dependent: :destroy
  after_commit :create_event_share_notifier, on: :create

  validates :user, :event, presence: true

  after_save :update_caches
  after_destroy :update_caches

  def update_caches
    user&.update_caches
  end

  # FeedActionable
  def can_create_feed_item?
    true
  end

  def feed_item_action
    FeedItemAction.find_by(slug: ::Api::Feeds::Items::Actions::EVENT_SHARE)
  end

  def feed_item_subscribers
    users.where.not(id: user.id)
  end

  def feed_item_actor
    user
  end

  def feed_item_object
    event
  end
end

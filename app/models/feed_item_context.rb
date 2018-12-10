class FeedItemContext < ActiveRecord::Base
  belongs_to :feed_item_action
  belongs_to :actor, polymorphic: true
  belongs_to :object, polymorphic: true
  has_one :feed_item

  validates :feed_item_action, :actor, :object, :feed_item, presence: true

  after_save :update_caches
  after_destroy :update_caches

  def update_caches
    object.update_caches if object&.respond_to?(:update_caches)
    actor.update_caches if actor&.respond_to?(:update_caches)
  end

  def message
    name = actor.name if actor.respond_to? :name
    {
      actor: name,
      action: feed_item_action.action,
      display: "#{name} #{feed_item_action.action}"
    }
  end
end

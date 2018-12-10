class FeedItemAction < ActiveRecord::Base
  include Indestructable

  has_many :feed_item_contexts

  translates :action
  validates :action, :slug, presence: true
end

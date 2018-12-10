class EventShareUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :event_share

  has_one :event, through: :event_share

  validates :user, :event_share, presence: true

  after_save :update_caches
  after_destroy :update_caches

  def update_caches
    user&.update_caches
  end
end

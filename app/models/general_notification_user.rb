class GeneralNotificationUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :general_notification

  validates :user, :general_notification, presence: true
end

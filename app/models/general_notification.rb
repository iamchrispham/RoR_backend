class GeneralNotification < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
  belongs_to :platform

  has_many :general_notification_users, dependent: :destroy
  has_many :users, through: :general_notification_users

  validates :message, :title, :owner, :platform, :target_mode, presence: true
  validates :message, length: {minimum: 1, maximum: 250}
  validates :title, length: {minimum: 1, maximum: 100}

  enum status: [:draft, :sending, :sent, :failed]

  has_one :general_notification_notifier, dependent: :destroy

  def send_notification
    create_general_notification_notifier
  end

  def status_class
    case status.to_sym
    when :sending
      'primary'
    when :sent
      'success'
    when :draft
      'warning'
    when :failed
      'error'
    end
  end

end

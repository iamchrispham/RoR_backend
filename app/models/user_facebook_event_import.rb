class UserFacebookEventImport < ActiveRecord::Base
  belongs_to :user

  enum status: [:pending, :in_progress, :completed]

  validates :user, :access_token, :status, presence: true

  after_create :start_import
  after_save :send_notifications_if_required

  has_one :user_facebook_event_import_notifier

  after_save :update_caches
  after_destroy :update_caches

  def update_caches
    user&.update_caches
  end

  def start_import
    UserFacebookEventImportWorker.perform_async(id)
  end

  def send_notifications_if_required
    if completed?
      create_user_facebook_event_import_notifier
    end
  end

  def message
    if failed_count > 0 && imported_count > 0
      I18n.t('notifiers.user_facebook_event_import.failed_and_imported.message', failed: failed_count, imported: imported_count)
    elsif failed_count > 0
      I18n.t('notifiers.user_facebook_event_import.failed.message', failed: failed_count)
    elsif imported_count > 1
      I18n.t('notifiers.user_facebook_event_import.imported.message', imported: imported_count)
    elsif imported_count > 0
      I18n.t('notifiers.user_facebook_event_import.imported_singular.message', imported: imported_count)
    else
      I18n.t('notifiers.user_facebook_event_import.nothing.message')
    end
  end
end

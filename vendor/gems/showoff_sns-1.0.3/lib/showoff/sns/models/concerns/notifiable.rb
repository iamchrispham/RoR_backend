module Showoff
  module SNS
    module Notifiable
      extend ActiveSupport::Concern

      included do
        has_many :devices, class_name: 'Showoff::SNS::Device', as: :owner
        has_many :active_devices, -> { where(active: true) }, class_name: 'Showoff::SNS::Device', as: :owner

        has_many :notified_objects, -> { order(created_at: :desc) }, class_name: 'Showoff::SNS::NotifiedObject', as: :notifiable

        has_many :pending_notified_objects, -> { where(status: Showoff::SNS::NotifiedObject.statuses['pending']) }, class_name: 'Showoff::SNS::NotifiedObject', as: :notifiable
        has_many :sent_notified_objects, -> { where(status: Showoff::SNS::NotifiedObject.statuses['sent']) }, class_name: 'Showoff::SNS::NotifiedObject', as: :notifiable
        has_many :delivered_notified_objects, -> { where(status: Showoff::SNS::NotifiedObject.statuses['delivered']) }, class_name: 'Showoff::SNS::NotifiedObject', as: :notifiable
        has_many :received_notified_objects, -> { where(status: Showoff::SNS::NotifiedObject.statuses['received']) }, class_name: 'Showoff::SNS::NotifiedObject', as: :notifiable
        has_many :failed_notified_objects, -> { where(status: Showoff::SNS::NotifiedObject.statuses['failed']) }, class_name: 'Showoff::SNS::NotifiedObject', as: :notifiable
        has_many :hidden_notified_objects, -> { where(status: Showoff::SNS::NotifiedObject.statuses['hidden']) }, class_name: 'Showoff::SNS::NotifiedObject', as: :notifiable

        has_many :notifications, as: :notifier, class_name: 'Showoff::SNS::Notification', through: :notified_objects

        has_many :pending_notifications, as: :notifier, class_name: 'Showoff::SNS::Notification', source: :notification, through: :pending_notified_objects
        has_many :sent_notifications, as: :notifier, class_name: 'Showoff::SNS::Notification', source: :notification, through: :sent_notified_objects
        has_many :delivered_notifications, as: :notifier, class_name: 'Showoff::SNS::Notification', source: :notification, through: :delivered_notified_objects
        has_many :received_notifications, as: :notifier, class_name: 'Showoff::SNS::Notification', source: :notification, through: :received_notified_objects
        has_many :failed_notifications, as: :notifier, class_name: 'Showoff::SNS::Notification', source: :notification, through: :failed_notified_objects
        has_many :hidden_notifications, as: :notifier, class_name: 'Showoff::SNS::Notification', source: :notification, through: :hidden_notified_objects
      end
    end
  end
end

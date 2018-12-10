module Showoff
  module SNS
    class NotifiedObject < ActiveRecord::Base
      self.table_name = :showoff_sns_notified_objects

      belongs_to :notification, foreign_key: :showoff_sns_notification_id
      belongs_to :notified_class, foreign_key: :showoff_sns_notified_class_id, class_name: 'Showoff::SNS::NotifiedClass'

      belongs_to :notifiable, polymorphic: true
      belongs_to :owner, polymorphic: true

      enum status: [:pending, :sending, :sent, :delivered, :received, :read, :hidden, :failed]

      before_create :set_pending

      private

      def set_pending
        self.status = :pending
      end
    end
  end
end

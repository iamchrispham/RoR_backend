module Showoff
  module SNS
    class Device < ActiveRecord::Base
      self.table_name = :showoff_sns_devices

      belongs_to :owner, polymorphic: true
      belongs_to :endpoint_owner, polymorphic: true

      before_validation :set_endpoint_arn

      validates :uuid, :platform, :push_token, :endpoint_arn, presence: true, length: { minimum: 1 }
      validates :uuid, uniqueness: { scope: [:owner_id, :owner_type] }

      private

      def set_endpoint_arn
        self.endpoint_arn = Showoff::SNS.endpoint_arn(self) if push_token
        true
      end
    end
  end
end

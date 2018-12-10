module Showoff
  module Notifiers
    class FacebookFriendNotifier < Showoff::SNS::Notifier::Base
      self.table_name = :showoff_facebook_friend_notifiers

      belongs_to :owner, polymorphic: true

      validates :owner_id, :owner_type, :facebook_username, presence: true
      validates :owner_id, uniqueness: { scope: [:owner_type] }

      after_commit :send_notification, on: :create

      def self.notification_type
        :facebook_friend
      end

      def should_notify?(target)
        !owner.id.eql?(target.id)
      end

      def subscribers
        facebook_service.friends(klass: owner.class)
      end

      def message(_target)
        platform = I18n.t('platform.name')
        I18n.t('concerning_services.facebook.notifier', platform: platform, facebook_username: facebook_username, username: owner.username)
      end

      def extra_information(_target)
        { owner_id: owner.id }
      end

      def resources(_target)
        { owner: serialized_resource(owner, "#{owner.class.name.pluralize}::OverviewSerializer".constantize) }
      end

      def set_owner
      end

      private

      def facebook_service
        @facebook_service ||= ::Showoff::Services::FacebookService.new(facebook_access_token: owner.facebook_access_token)
      end
    end
  end
end

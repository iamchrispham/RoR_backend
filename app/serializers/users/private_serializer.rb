module Users
  class PrivateSerializer < PublicSerializer#
    attributes :id, :account_type, :email, :gender, :date_of_birth, :eighteen_plus, :phone_number,
               :verifications_required, :seller_verifications_required, :country, :address, :business_details,
               :notifications_enabled, :active, :suspended, :counts, :tags, :notification_settings,
               :save_events_to_calendar, :facebook_profile_link, :linkedin_profile_link, :instagram_profile_link,
               :snapchat_profile_link

    def notification_settings
      serialized_resource(object.user_notification_setting, ::Users::NotificationSettings::OverviewSerializer)
    end

    def identification
      serialized_resource(object.identification, ::Identifications::OverviewSerializer)
    end

    def counts
      {
        notifications: object.notification_count
      }
    end

    def verifications_required
      {
        gender: object.gender.blank?,
        date_of_birth: object.date_of_birth.blank?,
        email: !object.confirmed?,
        phone_number: object.phone_number.blank?,
        identification: object.identifications.pending_verification_or_verified.empty?,
        profile_image: !object.image.file?,
        payment_method: !object.has_payment_method
      }
    end

    def seller_verifications_required
      verifications = {
        country: object.country_code.blank?,
        account_type: object.account_type.blank?,
        business_details: false,
        date_of_birth: object.date_of_birth.blank?,
        gender: object.gender.blank?,
        email: !object.confirmed?,
        phone_number: object.phone_number.blank?,
        identification: object.identifications.pending_verification_or_verified.empty?,
        address: object.current_address.blank?,
        bank_account: !object.has_bank_account
      }

      if object.account_type.present? && object.company?
        verifications[:business_details] = object.user_business.blank?
      end

      verifications
    end

    def country
      serialized_resource(object.country, ::Countries::OverviewSerializer)
    end

    def address
      serialized_resource(object.current_address, ::Addresses::OverviewSerializer)
    end

    def business_details
      serialized_resource(object.user_business, ::UserBusinessDetails::OverviewSerializer)
    end

    def tags
      serialized_resource(object.tags, ::Tags::TagSerializer)
    end
  end
end

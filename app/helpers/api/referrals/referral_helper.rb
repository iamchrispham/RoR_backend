module Api
  module Referrals
    module ReferralHelper

      def award_generic_credits(user, amount)
        return if user.nil?
        return if amount.nil?

        type = rental_credit_type
        creditor = platform

        if type.present? && creditor.present?
          user.award_credits(amount, creditor, type)
        end
      end

      def award_referral_credits(user, referred_user)
        type = referrals_credit_type
        creditor = platform
        if type.present? && creditor.present?
          user.award_credits(referral_user_invite_amount, creditor, type, referred_user)
        end
      end

      def registration_credit_type
        CreditType.registration
      end

      def referrals_credit_type
        CreditType.referral
      end

      def platform
        Platform.first
      end

      def referral_user_invite_amount
        ENV.fetch('REFERRAL_USER_INVITE_VALUE', 1000).to_i
      end

      def referral_user_registration_amount
        ENV.fetch('REFERRAL_USER_REGISTRATION_VALUE', 5000).to_i
      end

      def referral_user_invite_social_image_url
        "https://s3-eu-west-1.amazonaws.com/#{ENV['AWS_BUCKET']}/public/credit_type_registration_credits.png"
      end
    end
  end
end

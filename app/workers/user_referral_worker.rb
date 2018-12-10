class UserReferralWorker
  include ::Sidekiq::Worker
  include Api::ErrorHelper

  sidekiq_options queue: :default, retry: 1

  def perform(referral_code, referred_user_id)

    user = User.find_by(referral_code: referral_code)
    referred_user = User.find_by(id: referred_user_id)

    if user && referred_user
      user.refer_user(referred_user)
    end

  rescue StandardError => e
    report_error(e)
    Rails.logger.error(e.message)
  end
end

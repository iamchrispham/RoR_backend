class TokenGenerationService < ApiService
  include Api::DoorkeeperHelper

  attr_reader :suggest_account_merge

  def generate_for_facebook_user
    access_token = @params[:facebook_access_token]
    graph = Koala::Facebook::API.new(access_token)
    facebook_profile = graph.get_object('me', fields: %w(id email))

    @user = User.find_by(facebook_uid: facebook_profile['id'], email: facebook_profile['email'])
    @user = User.find_by(email: facebook_profile['email']) unless @user

    if @user

      if @user.active && !@user.suspended
        access_token = create_access_token(@user)

        if @user.facebook_uid.nil?
          access_token = create_temporary_access_token(@user)
          @suggest_account_merge = true
        end

        update_user_devices
        access_token

      elsif !@user.active
        register_error(Showoff::ResponseCodes::INVALID_API_KEY, I18n.t('api.responses.users.inactive'))
      elsif @user.suspended
        register_error(Showoff::ResponseCodes::INVALID_API_KEY, I18n.t('api.responses.users.suspended'))
      end
    else
      #register user
      user_params = @params[:user]
      user_params[:facebook_access_token] = access_token
      user_params[:facebook_uid] = facebook_profile['id']

      @user = User.new(user_params.except(:image_url, :image_data, :date_of_birth))
      @user.date_of_birth = Time.at(user_params[:date_of_birth].to_i) unless user_params[:date_of_birth].blank?

      if @user.save
        Showoff::Workers::ImageWorker.perform_async('User', @user.id, url: user_params[:image_url], data: user_params[:image_data])

        if @params[:referral_code]
          UserReferralWorker.perform_in(10.minutes, @params[:referral_code], @user.id)
        end

        update_user_devices
        create_access_token(@user)
      else
        register_error(Showoff::ResponseCodes::MISSING_ARGUMENT, @user.errors.full_messages.first)
      end

    end
  rescue ActiveRecord::RecordNotFound
    register_error(Showoff::ResponseCodes::NO_AUTHENTICATED_USER, I18n.t('api.responses.users.not_found'))
  rescue Koala::Facebook::AuthenticationError
    register_error(Showoff::ResponseCodes::NO_AUTHENTICATED_USER, I18n.t('api.responses.oauth.facebook.unauthorized'))
  end

  def generate_for_natural_user(strategy)
    response = strategy.authorize

    if response.status.eql?(:ok)
      @user = User.find_by(id: response.token.resource_owner_id)

      if @user
        if @user.active && !@user.suspended
          access_token = create_access_token(@user)

          update_user_devices
          access_token
        elsif !@user.active
          register_error(Showoff::ResponseCodes::INVALID_API_KEY, I18n.t('api.responses.users.inactive'))
        elsif @user.suspended
          register_error(Showoff::ResponseCodes::INVALID_API_KEY, I18n.t('api.responses.users.suspended'))
        end
      else
        register_error(Showoff::ResponseCodes::OBJECT_NOT_FOUND, I18n.t('api.responses.users.not_found'))
      end
    else
      register_error(Showoff::ResponseCodes::NO_AUTHENTICATED_USER, I18n.t('api.responses.invalid_credentials'))
    end
  end

  private
  def check_activation_status
    if !@user.active?
      register_error(Showoff::ResponseCodes::NO_AUTHENTICATED_USER, I18n.t('api.responses.users.deactivated'))
    end
  end

  def update_user_devices
    if @user
      device = @user.devices.find_by(uuid: params[:uuid])
      device.update_attributes(active: true) if device
    end
  end
end

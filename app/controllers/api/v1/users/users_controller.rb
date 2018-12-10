module Api
  module V1
    module Users
      class UsersController < ApiController
        skip_before_filter :doorkeeper_authorize!, :current_api_user, only: %i[create reset_password email group]
        before_filter :valid_client, only: %i[create reset_password email group]
        before_filter :set_added_facebook_uid, only: %i[update merge]

        def create
          if User.find_by(email: user_params[:email])
            error_response((t 'api.responses.users.account_exists'), Showoff::ResponseCodes::INVALID_ARGUMENT)
          else

            Time.zone = 'UTC'
            user = User.new(user_params.except(:image_url, :image_data, :date_of_birth, :referral_code, :tags))
            user.date_of_birth = Time.zone.at(user_params[:date_of_birth].to_i) unless user_params[:date_of_birth].blank?
            user.tos_acceptance_ip = current_request.ip
            user.tos_acceptance_timestamp = Time.zone.now

            if user.save
              user.tags = Tag.where(id: user_params[:tags]) unless user_params[:tags].blank?

              process_images(user)

              access_token = create_access_token(user)

              user.notify_facebook_friends if user.facebook_uid

              record_login(user, access_token)

              success_response(user: user.cached(user, type: :private), token: base_access_token_body(access_token))
            else
              active_record_error_response(user)
            end
          end
        end

        def update
          update_user = user_service.user_by_identifier(params[:id])

          if update_user && update_user.id.eql?(current_api_user.id)
            process_images(update_user)

            if update_user.update_attributes(user_params.except(:image_url, :image_data, :cover_image_url, :cover_image_data, :date_of_birth, :business, :address, :tags))

              update_user.update_attributes(date_of_birth: Time.at(user_params[:date_of_birth].to_i)) unless user_params[:date_of_birth].blank?
              update_user.business_details = user_params[:business] unless user_params[:business].blank?
              update_user.tags = Tag.where(id: user_params[:tags]) unless user_params[:tags].blank?

              if user_params[:address].present?
                update_user.addresses.create(user_params[:address])
              end

              update_user.notify_facebook_friends if @added_facebook_uid

              success_response(user: update_user.cached(current_api_user, type: :private))
            else
              active_record_error_response(update_user)
            end
          else
            unauthorized_response
          end
        end

        def show
          show_user = user_service.user_by_identifier(params[:id])
          if current_api_user
            if show_user
              private_type = show_user.eql?(current_api_user)
              success_response(user: show_user.cached(current_api_user, type: private_type ? :private : :public))
            else
              error_response((t 'api.responses.users.not_found'), Showoff::ResponseCodes::INVALID_ARGUMENT)
            end
          else
            unauthorized_response
          end
        end

        def reset_password
          user = User.find_by_email(params[:user][:email])
          if user
            user.send_reset_password_instructions
            default_response = default_response(Showoff::ResponseCodes::SUCCESS, (t 'api.responses.users.reset_password', email: user.email), nil)
            render json: default_response, status: Showoff::ResponseCodes::STATUS[Showoff::ResponseCodes::SUCCESS]
          else
            error_response((t 'api.responses.invalid_email', email: params[:email]), Showoff::ResponseCodes::INVALID_ARGUMENT)
          end
        end

        def email
          success_response(available: !User.where('lower(email) = ?', params[:email].downcase).first)
        end

        def group
          success_response(available: !User.where('lower(business_name) = ?', params[:group].downcase).first)
        end

        def password
          if current_api_user.valid_password?(params[:user][:current_password])
            password = params[:user][:new_password]
            if current_api_user.update_attributes(password: password, password_confirmation: password)

              token = generate_token_with_revoke_for_new_credentials(current_api_user)
              success_response(access_token_body(token))
            else
              active_record_error_response(current_api_user)
            end
          else
            error_response(t('api.responses.invalid_password'), Showoff::ResponseCodes::INVALID_ARGUMENT)
          end
        end

        def merge
          facebook_uid = params[:facebook_uid]
          facebook_access_token = params[:facebook_access_token]

          if facebook_uid.blank?
            error_response((t 'api.responses.users.missing.facebook_user_id'), Showoff::ResponseCodes::INVALID_ARGUMENT)
          elsif facebook_access_token.blank?
            error_response((t 'api.responses.users.missing.facebook_user_access_token'), Showoff::ResponseCodes::INVALID_ARGUMENT)
          elsif current_api_user.merge_facebook_for_user(facebook_uid, facebook_access_token)
            access_token = generate_token_from_temporary_access_token(current_api_user)

            current_api_user.notify_facebook_friends if @added_facebook_uid

            success_response(user: current_api_user.cached(current_api_user, type: :private), token: base_access_token_body(access_token))
          else
            error_response((t 'api.responses.users.unable_to_merge'), Showoff::ResponseCodes::INVALID_ARGUMENT)
          end
        end

        def send_verification_email
          if current_api_user
            current_api_user.send_confirmation_instructions
            default_response = default_response(Showoff::ResponseCodes::SUCCESS, (t 'api.responses.users.confirmation_email', email: current_api_user.email), nil)
            render json: default_response, status: Showoff::ResponseCodes::STATUS[Showoff::ResponseCodes::SUCCESS]
          else
            error_response((t 'api.responses.invalid_email', email: current_api_user.email), Showoff::ResponseCodes::INVALID_ARGUMENT)
          end
        end

        def facebook_friends
          facebook_access_token = params[:facebook_access_token]
          current_api_user.update_attributes(facebook_access_token: facebook_access_token)

          event = Event.active.find_by(id: params[:event_id])

          if facebook_access_token.blank?
            error_response((t 'api.responses.users.missing.facebook_user_access_token'), Showoff::ResponseCodes::INVALID_ARGUMENT)
          else
            friends = facebook_service.friends

            friends = friends.for_term(params[:term]) if params[:term]

            success_response(facebook_friends: friends.map {|user| user.cached(current_api_user, type: :public, event: event)})
          end
        rescue StandardError => e
          error_response(e.message, Showoff::ResponseCodes::INVALID_ARGUMENT)
        end

        def facebook_events
          facebook_access_token = params[:facebook_access_token]
          if facebook_access_token.blank?
            error_response((t 'api.responses.users.missing.facebook_user_access_token'), Showoff::ResponseCodes::INVALID_ARGUMENT)
          else
            current_api_user.import_facebook_events(facebook_access_token)
            success_response(
                importing: true,
                message: I18n.t('api.responses.users.facebook.events.import')
            )
          end
        rescue StandardError => e
          error_response(e.message, Showoff::ResponseCodes::INVALID_ARGUMENT)
        end

        def contacts
          users = User.none
          contacts = User.none

          unfiltered_contacts = params[:contacts]
          event = Event.active.find_by(id: params[:event_id])

          if unfiltered_contacts
            users = contact_service.users(unfiltered_contacts, params[:term])

            contacts = contact_service.contacts(unfiltered_contacts, params[:term])
          end

          users = users.where.not(id: event.attending_users) if event

          serialized_contacts = contacts.each do |contact|
            contact[:invited] = contact_service.invited?(contact, current_api_user, event, nil)
          end

          success_response(users: users.map {|user| user.cached(current_api_user, type: :public, event: event)}, contacts: serialized_contacts)
        end

        def invite
          contact = params[:contact]
          event = Event.find_by(id: params[:event_id])

          name = contact_service.invite(contact, current_api_user, event, params[:invitation_user_id])

          if contact_service.errors.nil?
            success_response(
                sent: true,
                message: I18n.t('api.responses.users.contacts.invite.sent', user: name)
            )
          else
            error = contact_service.errors.first
            error_response(error[:message], error[:type])
          end
        end

        private

        def process_images(user)
          if user_params[:image_url] || user_params[:image_data]
            Showoff::Workers::ImageWorker.perform_async('User', user.id, url: user_params[:image_url], data: user_params[:image_data])
          end

          if user_params[:cover_image_url] || user_params[:cover_image_data]
            Showoff::Workers::ImageWorker.perform_async('User', user.id, {url: user_params[:cover_image_url], data: user_params[:cover_image_data]}, :cover_image)
          end
        end

        def set_added_facebook_uid
          @added_facebook_uid ||= current_api_user && current_api_user.facebook_uid.nil? && current_api_user.facebook_friend_notifier.nil? && (!user_params[:facebook_uid].nil? || !params[:facebook_uid].nil?)
          true
        end

        def facebook_service
          @facebook_service ||= Showoff::Services::FacebookService.new(params)
        end

        def contact_service
          @contact_services ||= Showoff::Services::ContactService.new(params)
        end

        def user_params
          params.require(:user).permit!
        end
      end
    end
  end
end

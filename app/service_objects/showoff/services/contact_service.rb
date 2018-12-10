module Showoff
  module Services
    class ContactService < ApiService
      def contact_details(contact, go_user_id)
        go_user = User.find_by(id: go_user_id)

        email = phone = name = ""

        if contact
          email = contact[:email]
          phone = contact[:phone] || contact[:phone_numbers]
          name = contact[:name]
        end

        if go_user
          email = go_user.email if email.blank?
          phone = go_user.phone_number if phone.blank?
          name = go_user.name if name.blank?
        end

        [email, phone, name, go_user]
      end

      def users(contacts, term = nil)
        return User.none if contacts.blank?

        emails = contacts.map { |x| x[:email] }.compact
        phones = contacts.map { |x| x[:phone_numbers].map { |x| x.gsub('+', '00') } }.flatten.compact

        users = User.where(email: emails).or(User.where(phone_number: phones)).ordered_by_name

        users = users.for_term(term) if term

        users
      rescue StandardError
        User.none
      end

      def contacts(contacts, term = nil)
        emails = contacts.map { |x| x[:email] }.compact
        phones = contacts.map do |x|
          x[:phone_numbers] = [] unless x[:phone_numbers]
          x[:phone_numbers]&.map { |x| x.gsub('+', '00') }
        end.flatten.compact

        users = User.where(email: emails).or(User.where(phone_number: phones)).ordered_by_name

        user_emails = users.pluck(:email)
        user_phones = users.pluck(:phone_number)

        contacts.select! { |p| p[:name] =~ /.*#{term}.*/i } if term

        new_contacts = contacts.reject do |p|
          user_emails.include?(p[:email]) || (user_phones & p[:phone_numbers]).length.positive?
        end

        new_contacts.sort_by { |p| p[:name] }
      end

      def invited?(contact, user, event, go_user_id = nil)
        return false if (go_user_id.nil? && contact.blank?) || user.blank?

        email, phone, _, go_user = contact_details(contact, go_user_id)

        ContactInvite.find_by(user: user, email: email, phone_number: phone, go_user: go_user, event: event).present?
      end

      def invite(contact, user, event, go_user_id = nil)
        return if (go_user_id.nil? && contact.blank?) || user.blank?

        email, phone, name, go_user = contact_details(contact, go_user_id)

        contact_invite = ContactInvite.find_by(user: user, email: email, phone_number: phone, event: event, go_user: go_user)

        if contact_invite
          register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, I18n.t('api.responses.users.contacts.invite.already_sent', user: name))
        else
          contact_invite = ContactInvite.create(user: user, email: email, phone_number: phone, name: name, event: event, go_user: go_user)

          unless contact_invite.errors.empty?
            register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, contact_invite.errors.full_messages.first)
          end
        end

        name
      rescue StandardError => e
        register_error(Showoff::ResponseCodes::INTERNAL_ERROR, e.message)
      end
    end
  end
end

class EventMailer < ApplicationMailer
  layout false

  def invite(user_id, event_id)
    @user = User.find(user_id)
    @event = Event.find(event_id)

    mail to: @user.email, subject: default_i18n_subject(event_name: @event.title)
  end

  def contact_invite(email, name, user_id, event_id)
    @user = User.find(user_id)
    @event = Event.find(event_id)
    @email = email
    @name = name

    mail to: @email, subject: default_i18n_subject(event_name: @event.title)
  end
end

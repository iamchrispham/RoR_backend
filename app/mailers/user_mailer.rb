class UserMailer < ApplicationMailer
  layout false
  
  def invite(email, name, user_id)
    @user = User.find_by(id: user_id)
    @email = email
    @name = name

    mail to: @email
  end
end

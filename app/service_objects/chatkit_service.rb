require 'chatkit'

class ChatkitService < ApiService
  def create_room(user_id, name)
    check_chatkit_user(user_id)
    chatkit.create_room({
      creator_id: user_id.to_s,
      name: name,
      user_ids: [user_id.to_s]
      # private: true
    })
  end

  def check_chatkit_user(user_id)
    user = User.find(user_id)
    return if user.chatkit_user
    chatkit.create_user({ id: user_id.to_s, name: user.name })
    user.update(chatkit_user: true)
  end


  private

  def chatkit
    @chatkit ||= Chatkit::Client.new({
      instance_locator: 'v1:us1:4615c114-e7cc-4911-a3bd-9ecc9eb0e9f1',
      key: '025183de-9e91-4d17-a30d-ca0899990c23:j0H77cM83r2SYMQLtOlsj7DDyvXxQABKPvlsKwMebSE=',
    })
  end
end

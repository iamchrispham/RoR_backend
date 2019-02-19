require 'chatkit'

class ChatkitService < ApiService

  def initialize(user_id)
    @user_id = user_id.to_s
  end

  def create_user(name)
    chatkit.create_user(id: user_id, name: name)
  end

  def delete_user
    chatkit.delete_user(id: user_id)
  end


  def create_room(name)
    check_chatkit_user
    chatkit.create_room({
      creator_id: user_id,
      name: name[0..59],
      user_ids: [user_id]
      # private: true
    })
  end

  def check_chatkit_user
    user = User.find(user_id)
    return if user.pusher_id
    response = create_user(user.name)
    user.update(pusher_id: response[:body][:id] )
  end

  def add_user_to_chat_room(room_id)
    chatkit.add_users_to_room({
      room_id: room_id,
      user_ids: [user_id]
    })
  end

  private

  attr_reader :user_id

  def chatkit
    @chatkit ||= Chatkit::Client.new({
      instance_locator: 'v1:us1:4615c114-e7cc-4911-a3bd-9ecc9eb0e9f1',
      key: '025183de-9e91-4d17-a30d-ca0899990c23:j0H77cM83r2SYMQLtOlsj7DDyvXxQABKPvlsKwMebSE=',
    })
  end
end

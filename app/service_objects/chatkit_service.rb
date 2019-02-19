require 'chatkit'

class ChatkitService < ApiService
  def initialize(entity, opts = {})
    @entity = entity
    @entity_id = entity.pusher_id
    @opts = opts
  end

  def create_user
    chatkit.create_user(id: entity_id, name: entity.name)
  end

  def delete_user
    chatkit.delete_user(id: entity_id)
  end

  def create_room
    chatkit.create_room(
      creator_id: entity_id,
      name: room_name,
      user_ids: users_ids,
      private: true
    )
  end

  def add_users_to_chat_room
    chatkit.add_users_to_room({
      room_id: opts[:room_id],
      user_ids: users_ids
    })
  end

  def remove_users_from_chat_room
    chatkit.remove_users_from_room({
      room_id: opts[:room_id],
      user_ids: users_ids
    })
  end

  private

  attr_reader :entity, :entity_id, :opts

  def chatkit
    @chatkit ||= Chatkit::Client.new({
      instance_locator: 'v1:us1:4615c114-e7cc-4911-a3bd-9ecc9eb0e9f1',
      key: '025183de-9e91-4d17-a30d-ca0899990c23:j0H77cM83r2SYMQLtOlsj7DDyvXxQABKPvlsKwMebSE=',
    })
  end

  def room_name
    name = opts[:name] || ([entity_id] + opts[:recipient_ids]).join('+')
    name[0..59]
  end

  def users_ids
    return [entity_id] unless opts[:recipient_ids]

    [entity_id] + opts[:recipient_ids]
  end
end

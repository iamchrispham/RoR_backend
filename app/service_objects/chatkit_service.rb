require 'chatkit'

class ChatkitService < ApiService
  def initialize(admin_id, name, source_type)
    @admin_id = admin_id
    @name = name
    @source_type = source_type
  end

  def create_room
    binding.pry
    chatkit.create_room({
      creator_id: admin_id,
      name: name,
      user_ids: [admin_id],
      private: true,
      custom_data: { source_type: source_type }
    })
  end
  #
  # def add_users_to_room
  #   chatkit.add_users_to_room({
  #     room_id: room_id,
  #     user_ids: [group.users]
  #   })
  # end

  private

  attr_reader :admin_id, :name, :source_type

  def chatkit
    @chatkit ||= Chatkit::Client.new({
      instance_locator: 'v1:us1:4615c114-e7cc-4911-a3bd-9ecc9eb0e9f1',
      key: '025183de-9e91-4d17-a30d-ca0899990c23:j0H77cM83r2SYMQLtOlsj7DDyvXxQABKPvlsKwMebSE=',
    })
  end
end

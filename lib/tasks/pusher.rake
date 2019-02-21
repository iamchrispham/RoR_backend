namespace :pusher do
  desc 'Create users on pusher'
  task create_users: :environment do
    users = User.where(pusher_id: nil)

    users.find_each do |user|
      user.create_pusher_user
    end
  end

  task create_rooms_for_events: :environment do
    events = Event.joins("LEFT OUTER JOIN chats ON chats.chatable_id = events.id").where("chats.id IS null")

    events.find_each do |event|
      event.init_chat
    end
  end

  task create_rooms_for_groups: :environment do
    groups = Group.joins("LEFT OUTER JOIN chats ON chats.chatable_id = groups.id").where("chats.id IS null")

    groups.find_each do |group|
      group.init_chat
    end
  end
end

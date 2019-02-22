class RunPusherTask < ActiveRecord::Migration
  def change
    Rake::Task['pusher:create_users'].invoke
    Rake::Task['pusher:create_rooms_for_events'].invoke
    Rake::Task['pusher:create_rooms_for_groups'].invoke
  end
end

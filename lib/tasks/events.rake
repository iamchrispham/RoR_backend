namespace :events do
  desc 'Notify possibly attendees of upcoming events'
  task notify_upcoming_events: :environment do
    tomorrow = Date.tomorrow + 1.day

    events = Event.active.where('date >= ? AND date < ?', tomorrow.beginning_of_day, tomorrow.end_of_day)

    events.find_each do |event|
      event.create_upcoming_event_notifier unless event.upcoming_event_notifier
    end
  end
end

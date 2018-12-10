class ExampleNotifier < Showoff::SNS::Notifier::Base
  after_create :send_notification

  def self.notification_type
    # Define your notification type here
    :example
  end

  def subscribers
    # Define your notification subscribers here
    ExampleNotifiable.all
  end

  def message(target)
    # Define your notification message here
    "ExampleNotifiable #{target.id}"
  end

  def extra_information(target)
    # Define your notification extra information here
    { notifiable_id: target.id }
  end

  def should_notify?(_target)
    true
  end
end

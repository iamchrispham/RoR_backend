puts '###################'
puts 'Creating Platform'
begin
  platform = Platform.create(email: 'operations@mygo.io', name: 'Go!')
  platform.update_attributes(image: URI.parse('https://s3-eu-west-1.amazonaws.com/go-api-production/public/platform_icon.png'))
rescue StandardError => e
  puts e.inspect
end

puts '###################'
puts 'Creating Identification Types'
IdentificationType.find_or_create_by(name: 'Passport')
IdentificationType.find_or_create_by(name: 'Drivers Licence')
IdentificationType.find_or_create_by(name: 'Government I.D')


puts '###################'
puts 'Creating Event Contribution Types'
type = EventContributionType.find_or_create_by(slug: 'contribution')
type.name = 'Contribution'
type.cta_title = 'Contribution'
type.cta_description = 'Would you like to make a Contribution?'
type.change_amount_title = 'Change Contribution'
type.change_amount_description = 'Change contribution amount?'
type.save!

puts '###################'
puts 'Creating Notification Settings'
NotificationSetting.find_or_create_by(
    name: 'Event Invitation',
    description: 'Receive a notification when you are invited to an event',
    slug: 'event_invitation'
)

NotificationSetting.find_or_create_by(
    name: 'Event Attendance Request',
    description: "Receive a notification when you receive an event attendance request for one of your events or your attendance requests for someone else's event are responded to",
    slug: 'event_attendee_request'
)

NotificationSetting.find_or_create_by(
    name: 'Event Attendance',
    description: 'Receive a notification when someone decides if they are going, not going or maybe going to one of your events',
    slug: 'event_owner_attendee'
)
NotificationSetting.find_or_create_by(
    name: 'Event Share',
    description: 'Receive a notification when one of your friends shares an event with you',
    slug: 'event_share'
)
NotificationSetting.find_or_create_by(
    name: 'Event Timeline Comment',
    description: 'Receive a notification when someone comments on your event timeline content',
    slug: 'event_timeline_item_comment'
)
NotificationSetting.find_or_create_by(
    name: 'Event Timeline Like',
    description: 'Receive a notification when someone likes your event timeline content',
    slug: 'event_timeline_item_like'
)

NotificationSetting.find_or_create_by(
    name: 'Friend Request',
    description: 'Receive a notification when someone sends you a friend request',
    slug: 'friend_request'
)

NotificationSetting.find_or_create_by(
    name: 'Friend Request Accepted',
    description: 'Receive a notification when someone accepts your friend request',
    slug: 'friendship_created'
)

NotificationSetting.find_or_create_by(
    name: 'Facebook Event Import',
    description: 'Receive notifications when your Facebook Events are finished importing',
    slug: 'facebook_event_import'
)

NotificationSetting.find_or_create_by(
    name: 'Go! Notifications',
    description: 'Receive informative notifications from Go! from time to time',
    slug: 'general'
)

NotificationSetting.find_or_create_by(
    name: 'Event Chat',
    description: 'Receive notifications for new messages posted in event chat',
    slug: 'event_chat'
)

NotificationSetting.find_or_create_by(
    name: 'Other Chat',
    description: 'Receive notifications for new messages in chat groups not related to events',
    slug: 'other_chat'
)

puts '###################'
puts 'Creating Feed Item Actions'
FeedItemAction.find_or_create_by(
    action: I18n.t('models.feeds.actions.event_attendee'),
    slug: Api::Feeds::Items::Actions::EVENT_ATTENDEE
)

FeedItemAction.find_or_create_by(
    action: I18n.t('models.feeds.actions.event_shared'),
    slug: Api::Feeds::Items::Actions::EVENT_SHARE
)

FeedItemAction.find_or_create_by(
    action: I18n.t('models.feeds.actions.event_timeline_item_post'),
    slug: Api::Feeds::Items::Actions::EVENT_TIMELINE_ITEM_POST
)

FeedItemAction.find_or_create_by(
    action: I18n.t('models.feeds.actions.event_timeline_item_comment'),
    slug: Api::Feeds::Items::Actions::EVENT_TIMELINE_ITEM_COMMENT
)

FeedItemAction.find_or_create_by(
    action: I18n.t('models.feeds.actions.event_timeline_item_like'),
    slug: Api::Feeds::Items::Actions::EVENT_TIMELINE_ITEM_LIKE
)
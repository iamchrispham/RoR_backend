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

puts '###################'
puts 'Creating College group'
file_io = File.new(Rails.root.join('spec/support/fixtures/image.png').to_s)

if (user = User.find_by(email: 'syber@junkie.com')).blank?
  user =
    User.create!(
      email: 'syber@junkie.com',
      first_name: 'Syber',
      last_name: 'Junkie',
      password: 'password',
      password_confirmation: 'password'
    )
end

if (friend = User.find_by(email: 'syber-friend@junkie.com')).blank?
  friend =
    User.create!(
      email: 'syber-friend@junkie.com',
      first_name: 'Syber',
      last_name: 'Junkie Friend',
      password: 'password',
      password_confirmation: 'password'
    )
  user.friends << friend
end

group = Group.find_by(category: :college, name: 'Trinity College Dublin')

if group.blank?
  group =
    Group.create!(
      category: :college,
      name: 'Trinity College Dublin',
      about: 'Welcome to the official Trinity College Dublin page. Here you will have easy access to all our news, college events, clubs, societies and much more. You can also avail of special offers which may benefit you from companies.',
      location: 'Location within central Dublin',
      image: file_io,
      owner: user,
      phone: '+1234567890',
      email: 'test-test@gmail.com',
      website: 'https://example.com/blah',
      facebook_profile_link: 'https://facebook.com/blah'
    )
end

subgroup = Group.find_by(category: :society, name: 'Clinical Therapies Society')

if Contact.find_by(category: :phone, details: '+1234567890').blank?
  group.contacts << Contact.create!(category: :phone, details: '+1234567890', image: file_io)
end

if Contact.find_by(category: :url, details: 'https://facebook.com/blah').blank?
  group.contacts << Contact.create!(category: :url, details: 'https://facebook.com/blah', image: file_io)
end

if Contact.find_by(category: :email, details: 'test-test@gmail.com').blank?
  group.contacts << Contact.create!(category: :email, details: 'test-test@gmail.com', image: file_io)
end

group.active_members << user unless group.active_members.where('memberships.user_id = ?', user.id).exists?
group.active_members << friend unless group.active_members.where('memberships.user_id = ?', friend.id).exists?

if Post.find_by(title: 'Christmas tree lighting ceremony on 28 November at 5 pm').blank?
  news = Post.create!(
    title: 'Christmas tree lighting ceremony on 28 November at 5 pm',
    details: 'The countdown to Christmas will start tomorrow evening with a Christmas Tree Lighting ceremony',
    image: file_io
  )
  group.posts << news
end

if subgroup.blank?
  subgroup =
    Group.create!(
      category: :society,
      name: 'Clinical Therapies Society',
      about: 'UCC society for Occupational Therapy (OT), Speech and Language Therapy (SLT), MSc Audiology, MSc Physiotherapy and MSc Diagnostic Radiography students.',
      location: 'Location within central Dublin',
      image: file_io,
      owner: user,
      parent: group
    )
end

if subgroup.contacts.find_by(category: :url, details: 'https://facebook.com/blah').blank?
  subgroup.contacts << Contact.create!(category: :url, details: 'https://facebook.com/blah', image: file_io)
end

if SpecialOffer.find_by(title: 'Future Offer. 10 for £10 Kids Picture Books!').blank?
  offer = SpecialOffer.create!(
    title: 'Future Offer. 10 for £10 Kids Picture Books!',
    details: 'Buy Kids Books online in our fantastic 10 for £10 offer!',
    image: file_io,
    starts_at: 2.days.from_now,
    ends_at: 5.days.from_now,
    publish_on: 1.day.from_now
  )
  OfferApproval.create!(special_offer: offer, user: user, group: group)
end

if SpecialOffer.find_by(title: 'Ongoing offer. Great value Easter Crafts from Easter Bonnet making to Easter Egg Hunt kits').blank?
  SpecialOffer.create!(
    title: 'Ongoing offer. Great value Easter Crafts from Easter Bonnet making to Easter Egg Hunt kits',
    details: 'Buy cheap Easter Crafts online at The Works, all Easter crafting materials are available to buy at The Works.',
    image: file_io,
    starts_at: 1.days.ago,
    ends_at: 2.days.from_now,
    publish_on: 2.day.ago
  )
end

if SpecialOffer.find_by(title: 'Past offer. Great value Easter Crafts from Easter Bonnet making to Easter Egg Hunt kits').blank?
  SpecialOffer.create!(
    title: 'Past offer. Great value Easter Crafts from Easter Bonnet making to Easter Egg Hunt kits',
    details: 'Buy cheap Easter Crafts online at The Works, all Easter crafting materials are available to buy at The Works.',
    image: file_io,
    starts_at: 3.days.ago,
    ends_at: 2.days.ago,
    publish_on: 5.day.ago
  )
end

if SpecialOffer.find_by(title: 'Past approved offer. Great value Easter Crafts from Easter Bonnet making to Easter Egg Hunt kits').blank?
  past_offer = SpecialOffer.create!(
    title: 'Past approved offer. Great value Easter Crafts from Easter Bonnet making to Easter Egg Hunt kits',
    details: 'Buy cheap Easter Crafts online at The Works, all Easter crafting materials are available to buy at The Works.',
    image: file_io,
    starts_at: 3.days.ago,
    ends_at: 2.days.ago,
    publish_on: 5.day.ago
  )
  OfferApproval.create!(special_offer: past_offer, user: user, group: group)
end

### Adding developers to a group

if (dev1 = User.find_by(email: 'shovon54@gmail.com')).blank?
  dev1 =
    User.create!(
      email: 'shovon54@gmail.com',
      first_name: 'Tasnim',
      last_name: 'Shovon',
      password: 'password',
      password_confirmation: 'password'
    )
end
group.active_members << dev1 unless group.active_members.where('memberships.user_id = ?', dev1.id).exists?

if (dev2 = User.find_by(email: 'sajid.sust.cse@gmail.com')).blank?
  dev2 =
    User.create!(
      email: 'sajid.sust.cse@gmail.com',
      first_name: 'Sajid',
      last_name: 'Sust',
      password: 'password',
      password_confirmation: 'password'
    )
end
group.active_members << dev2 unless group.active_members.where('memberships.user_id = ?', dev2.id).exists?

if (dev3 = User.find_by(email: 'sharker.ratul.08@gmail.com')).blank?
  dev3 =
    User.create!(
      email: 'sharker.ratul.08@gmail.com',
      first_name: 'Sharker',
      last_name: 'Ratul',
      password: 'password',
      password_confirmation: 'password'
    )
end
group.active_members << dev3 unless group.active_members.where('memberships.user_id = ?', dev3.id).exists?

normal_group = Group.find_by(category: :normal, name: 'Normal Group Example')

if normal_group.blank?
  normal_group =
    Group.create!(
      category: :normal,
      name: 'Normal Group Example',
      about: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      location: 'Location within central Dublin',
      image: file_io,
      owner: user,
      phone: '+1234567890',
      email: 'test-test@gmail.com',
      website: 'https://example.com/blah',
      facebook_profile_link: 'https://facebook.com/blah',
      linkedin_profile_link: 'https://example.com/blah',
      instagram_profile_link: 'https://example.com/blah',
      snapchat_profile_link: 'https://example.com/blah'
    )
end

normal_group.active_members << dev1 unless normal_group.active_members.where('memberships.user_id = ?', dev1.id).exists?
normal_group.active_members << dev2 unless normal_group.active_members.where('memberships.user_id = ?', dev2.id).exists?
normal_group.active_members << dev3 unless normal_group.active_members.where('memberships.user_id = ?', dev3.id).exists?

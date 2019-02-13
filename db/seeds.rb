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
RequestStore.write(:current_api_user, User.find_by(email: 'shovon54@gmail.com'))

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

if (dev4 = User.find_by(email: 'akhouad@yahoo.fr')).blank?
  dev4 =
    User.create!(
      email: 'akhouad@yahoo.fr',
      first_name: 'Amine',
      last_name: 'Akhouad',
      password: 'password',
      password_confirmation: 'password'
    )
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
      owner: dev1,
      phone: '+1234567890',
      email: 'test-test@gmail.com',
      website: 'https://example.com/blah',
      facebook_profile_link: 'https://facebook.com/blah',
      email_domain: 'gmail.com'
    )
end

group1 = Group.find_by(category: :college, name: "Trinity College Dublin #{dev4.name}")
if group1.blank?
  group1 =
    Group.create!(
      category: :college,
      name: "Trinity College Dublin #{dev4.name}",
      about: 'Welcome to the official Trinity College Dublin page. Here you will have easy access to all our news, college events, clubs, societies and much more. You can also avail of special offers which may benefit you from companies.',
      location: 'Location within central Dublin',
      image: file_io,
      owner: dev4,
      phone: '+1234567890',
      email: 'test-test@gmail.com',
      website: 'https://example.com/blah',
      facebook_profile_link: 'https://facebook.com/blah',
      email_domain: 'gmail.com'
    )
end

college = Group.find_by(category: :college, name: 'University of Dublin')
if college.blank?
  college =
    Group.create!(
      category: :college,
      name: 'University of Dublin',
      about: 'The University of Dublin, corporately designated the Chancellor, Doctors and Masters of the University of Dublin, is a university located in Dublin, Ireland. It is the degree awarding body for Trinity College Dublin.',
      location: 'Dublin, Ireland',
      image: file_io,
      owner: dev1,
      phone: '+1234567890',
      email: 'dublin-univ@gmail.com',
      website: 'https://www.tcd.ie',
      facebook_profile_link: 'https://facebook.com/blah',
      email_domain: 'gmail.com'
    )
end

college1 = Group.find_by(category: :college, name: "University of Dublin #{dev4.name}")
if college1.blank?
  college1 =
    Group.create!(
      category: :college,
      name: "University of Dublin #{dev4.name}",
      about: 'The University of Dublin, corporately designated the Chancellor, Doctors and Masters of the University of Dublin, is a university located in Dublin, Ireland. It is the degree awarding body for Trinity College Dublin.',
      location: 'Dublin, Ireland',
      image: file_io,
      owner: dev4,
      phone: '+1234567890',
      email: 'dublin-univ@gmail.com',
      website: 'https://www.tcd.ie',
      facebook_profile_link: 'https://facebook.com/blah',
      email_domain: 'gmail.com'
    )
end

meetup1 = Group.find_by(category: :meetup, name: 'Meetup brings people together in thousands of cities')
if meetup1.blank?
  meetup1 =
    Group.create!(
      category: :meetup,
      name: 'WooCommerce Meetups',
      about: 'Local Meetups, organized by our amazing community.',
      location: 'Dublin, Ireland',
      image: file_io,
      owner: dev1,
      phone: '+1234567890',
      email: 'dublin-univ@gmail.com',
      website: 'https://www.tcd.ie',
      facebook_profile_link: 'https://facebook.com/blah',
      email_domain: 'gmail.com'
    )
end

meetup2 = Group.find_by(category: :meetup, name: 'Meetup brings people together in thousands of cities')
if meetup2.blank?
  meetup2 =
    Group.create!(
      category: :meetup,
      name: 'Meetup brings people together in thousands of cities',
      about: 'Meetup is a service used to organize online groups that host in-person events for people with similar interests.',
      location: 'Dublin, Ireland',
      image: file_io,
      owner: dev1,
      phone: '+1234567890',
      email: 'dublin-univ@gmail.com',
      website: 'https://www.tcd.ie',
      facebook_profile_link: 'https://facebook.com/blah',
      email_domain: 'gmail.com'
    )
end

meetup1.active_members << dev1 unless meetup1.active_members.where('memberships.user_id = ?', dev1.id).exists?
meetup1.active_members << dev2 unless meetup1.active_members.where('memberships.user_id = ?', dev2.id).exists?
meetup1.active_members << dev3 unless meetup1.active_members.where('memberships.user_id = ?', dev3.id).exists?
meetup1.active_members << dev4 unless meetup1.active_members.where('memberships.user_id = ?', dev3.id).exists?

meetup2.active_members << dev1 unless meetup2.active_members.where('memberships.user_id = ?', dev1.id).exists?
meetup2.active_members << dev2 unless meetup2.active_members.where('memberships.user_id = ?', dev2.id).exists?
meetup2.active_members << dev3 unless meetup2.active_members.where('memberships.user_id = ?', dev3.id).exists?
meetup2.active_members << dev4 unless meetup2.active_members.where('memberships.user_id = ?', dev3.id).exists?

subgroup = Group.find_by(category: :society, name: 'Clinical Therapies Society')

if subgroup.blank?
  subgroup =
    Group.create!(
      category: :society,
      name: 'Clinical Therapies Society',
      about: 'UCC society for Occupational Therapy (OT), Speech and Language Therapy (SLT), MSc Audiology, MSc Physiotherapy and MSc Diagnostic Radiography students.',
      location: 'Location within central Dublin',
      image: file_io,
      owner: dev1,
      parent: group
    )
end

society = Group.find_by(category: :society, name: 'Dead Poets Society')

if society.blank?
  society =
    Group.create!(
      category: :society,
      name: 'Dead Poets Society',
      about: 'Dead Poets Society is a 1989 American drama film directed by Peter Weir, written by Tom Schulman, and starring Robin Williams. Set in 1959 at the fictional elite conservative Vermont boarding school Welton Academy, it tells the story of an English teacher who inspires his students through his teaching of poetry.',
      location: 'Location within central Dublin',
      image: file_io,
      owner: dev1,
      parent: group
    )
end

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
group.active_members << dev4 unless group.active_members.where('memberships.user_id = ?', dev4.id).exists?

if (news1 = Post.find_by(title: 'Christmas tree lighting ceremony on 28 November at 5 pm')).blank?
  news1 = Post.create!(
    title: 'Christmas tree lighting ceremony on 28 November at 5 pm',
    details: 'The countdown to Christmas will start tomorrow evening with a Christmas Tree Lighting ceremony',
    image: file_io
  )
end
group.posts << news1 unless group.posts.include?(news1)

if (news2 = Post.find_by(title: 'Christmas tree lighting ceremony on 29 November at 5 pm')).blank?
  news2 = Post.create!(
    title: 'Christmas tree lighting ceremony on 29 November at 5 pm',
    details: 'The countdown to Christmas will start tomorrow evening with a Christmas Tree Lighting ceremony',
    image: file_io
  )
end
group.posts << news2 unless group.posts.include?(news2)

if (news3 = Post.find_by(title: 'Christmas tree lighting ceremony on 30 November at 5 pm')).blank?
  news3 = Post.create!(
    title: 'Christmas tree lighting ceremony on 30 November at 5 pm',
    details: 'The countdown to Christmas will start tomorrow evening with a Christmas Tree Lighting ceremony',
    image: file_io
  )
end
group.posts << news3 unless group.posts.include?(news3)

if subgroup.contacts.find_by(category: :url, details: 'https://facebook.com/blah').blank?
  subgroup.contacts << Contact.create!(category: :url, details: 'https://facebook.com/blah', image: file_io)
end

SpecialOffer.delete_all
future_offer = SpecialOffer.create!(
  title: 'Approved Future Offer. 10 for £10 Kids Picture Books!',
  details: 'Buy Kids Books online in our fantastic 10 for £10 offer!',
  image: file_io,
  starts_at: 2.days.from_now,
  ends_at: 5.days.from_now,
  publish_on: 1.day.from_now,
  advertiser: 'Easter Crafts',
  location: 'Location within central Dublin'
)
OfferApproval.create!(special_offer: future_offer, user: dev4, group: group1, active: true)

ongoing_offer = SpecialOffer.create!(
  title: 'Approved Ongoing Offer. Great value Easter Crafts from Easter Bonnet making to Easter Egg Hunt kits',
  details: 'Buy cheap Easter Crafts online at The Works, all Easter crafting materials are available to buy at The Works.',
  advertiser: 'Easter Crafts',
  location: 'Location within central Dublin',
  image: file_io,
  starts_at: 1.day.ago,
  ends_at: 2.days.from_now,
  publish_on: 2.days.ago
)
OfferApproval.create!(special_offer: ongoing_offer, user: dev4, group: group1, active: true)

SpecialOffer.create!(
  title: 'Past offer. Great value Easter Crafts from Easter Bonnet making to Easter Egg Hunt kits',
  details: 'Buy cheap Easter Crafts online at The Works, all Easter crafting materials are available to buy at The Works.',
  image: file_io,
  starts_at: 3.days.ago,
  ends_at: 2.days.ago,
  publish_on: 5.days.ago,
  advertiser: 'Easter Crafts',
  location: 'Location within central Dublin'
)

past_offer = SpecialOffer.create!(
  title: 'Past approved offer. Great value Easter Crafts from Easter Bonnet making to Easter Egg Hunt kits',
  details: 'Buy cheap Easter Crafts online at The Works, all Easter crafting materials are available to buy at The Works.',
  image: file_io,
  starts_at: 3.days.ago,
  ends_at: 2.days.ago,
  publish_on: 5.days.ago,
  advertiser: 'Easter Crafts',
  location: 'Location within central Dublin'
)
OfferApproval.create!(special_offer: past_offer, user: dev4, group: group1, active: true)

### Adding developers to a group
group.active_members << dev1 unless group.active_members.where('memberships.user_id = ?', dev1.id).exists?
group.active_members << dev2 unless group.active_members.where('memberships.user_id = ?', dev2.id).exists?
group.active_members << dev3 unless group.active_members.where('memberships.user_id = ?', dev3.id).exists?
group.active_members << dev4 unless group.active_members.where('memberships.user_id = ?', dev3.id).exists?

group1.active_members << dev1 unless group.active_members.where('memberships.user_id = ?', dev1.id).exists?
group1.active_members << dev2 unless group.active_members.where('memberships.user_id = ?', dev2.id).exists?
group1.active_members << dev3 unless group.active_members.where('memberships.user_id = ?', dev3.id).exists?
group1.active_members << dev4 unless group.active_members.where('memberships.user_id = ?', dev3.id).exists?


normal_group = Group.find_by(category: :normal, name: 'Normal Group Example')

if normal_group.blank?
  normal_group =
    Group.create!(
      category: :normal,
      name: 'Normal Group Example',
      about: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      location: 'Location within central Dublin',
      image: file_io,
      owner: dev1,
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

LikedOffer.delete_all
LikedOffer.create!(special_offer: future_offer, user: dev4, group: group)
LikedOffer.create!(special_offer: future_offer, user: dev1, group: group)
LikedOffer.create!(special_offer: ongoing_offer, user: dev4, group: group)

society_event = Event.find_by(title: 'Poetry evening')

if society_event.blank?
  Event.create!(
    title: 'Poetry evening',
    description: 'Poetry Evening. Set in the historic grade II listed Old Westminster Library; The Cinnamon Club will play host to its first poetry event on Monday 12th May',
    time: '11:13',
    date: 'Monday 12th May',
    latitude: '13.67',
    longitude: '12.67',
    categories: '#dead_poets',
    event_ownerable: society
  )
end

society_event1 = Event.find_by(title: 'Poetry club meeting')

if society_event1.blank?
  Event.create!(
    title: 'Poetry club meeting',
    description: 'Poetry club meeting. Set in the historic grade II listed Old Westminster Library; The Cinnamon Club will play host to its first poetry event on Monday 12th May',
    time: '11:13',
    date: 'Monday 12th May',
    latitude: '13.67',
    longitude: '12.67',
    categories: '#dead_poets, #dead_society',
    event_ownerable: society
  )
end

group_event = Event.find_by(title: 'WHAM Lunch & Learn: The Vaping Epidemic on College Campuses - To rip a JUUL')

if group_event.blank?
  Event.create!(
    title: 'WHAM Lunch & Learn: The Vaping Epidemic on College Campuses - To rip a JUUL',
    description: 'WHAM Lunch & Learn: The Vaping Epidemic on College Campuses - To rip a JUUL',
    time: '11:13',
    date: 'Monday 12th May',
    latitude: '13.67',
    longitude: '12.67',
    categories: '#WHAM',
    event_ownerable: group
  )
end

group_event1 = Event.find_by(title: 'Drop-in appointments in the Olin-Rice Hub')

if group_event1.blank?
  Event.create!(
    title: 'Drop-in appointments in the Olin-Rice Hub',
    description: 'Drop-in appointments in the Olin-Rice Hub',
    time: '11:13',
    date: 'Monday 12th May',
    latitude: '13.67',
    longitude: '12.67',
    categories: '#Olin_Rice',
    event_ownerable: group
  )
end


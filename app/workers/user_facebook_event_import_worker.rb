class UserFacebookEventImportWorker
  include ::Sidekiq::Worker
  include Api::ErrorHelper

  sidekiq_options queue: :default, retry: 1

  def perform(id)
    facebook_import = UserFacebookEventImport.find_by(id: id)
    if facebook_import
      facebook_import.in_progress!

      user = facebook_import.user
      access_token = facebook_import.access_token

      if user && access_token

        graph = facebook_client(access_token)
        if graph
          profile = graph.get_object("me")
          debug("Facebook Profile: #{profile.inspect}")

          facebook_uid = profile['id']
          user.update_attributes(facebook_access_token: access_token, facebook_uid: facebook_uid)
          events = graph.get_connections(user.facebook_uid, 'events')
          debug("Facebook Events (both owned and others): #{events.inspect}")

          # filter for owner events
          owner_events = filtered_owner_events(facebook_import, events)
          debug("Facebook Owner Events: #{owner_events.inspect}")

          # process the owner events
          process_owner_events(facebook_import, owner_events) if owner_events.size > 0
        end
      end

      facebook_import.completed!
    end
  rescue StandardError => e
    report_error(e)
    Rails.logger.error(e.message)
  end

  private

  def debug(string)
    puts string.inspect
  end

  def facebook_client(access_token)
    Koala::Facebook::API.new(access_token)
  end

  def filtered_owner_events(facebook_import, events)
    graph = facebook_client(facebook_import.access_token)
    owner_events = []
    if graph.present?
      debug("Events to Filter: #{events.inspect}")

      events.each do |event|
        event_id = event['id']

        fb_event = graph.get_connection(
          event_id,
          nil,
          {
            fields: 'name,owner,start_time,end_time,cover,place,description'
          }
        )
        debug("FB Event to Check: #{fb_event.inspect}")

        if fb_event.present?
          event_id = fb_event['id']

          owner = fb_event['owner']
          owner_id = owner['id']
          if owner_id == facebook_import.user.facebook_uid
            owner_events << event_id
            debug("Found an owned Event: #{event_id}")
          end
        end
      end
    end

    debug("Filtered Owner Events: #{owner_events}")
    owner_events
  end

  def process_owner_events(facebook_import, owner_events)
    graph = facebook_client(facebook_import.access_token)
    debug("Owned Events to Import or reactivate: #{owner_events.inspect}")
    events = graph.get_objects(
      owner_events.join(','),
      fields
    )

    debug("Owned Events fetched from Facebook: #{events.inspect}")

    events.values.each do |event|
      fb_event = graph.get_connection(
        event['id'],
        nil,
        fields
      )

      debug("Facebook Event Fetched: #{fb_event.inspect}")

      debug("Finding Matching FB Event in DB: #{fb_event['id']}")
      saved_event = facebook_import.user.events.find_by(facebook_id: fb_event['id'])

      if saved_event.nil?
        debug("Existing Fb Event not Found. Creating")
        params = event_params(fb_event)
        debug("Event Creating Params: #{params}")
        event = events_service.create(params, facebook_import.user)
        if events_service.errors.nil?
          debug("Imported Event: #{event.inspect}")
          facebook_import.update_attributes(imported_count: facebook_import.imported_count + 1)
        else
          debug("Error Creating Event: #{events_service.errors.inspect}")
          facebook_import.update_attributes(failed_count: facebook_import.failed_count + 1)
        end
      else
        debug("Found Existing Event. Activating")
        saved_event.activate!
      end
    end
  end

  def event_params(event)
    start_date = Date.parse(event['start_time']) unless event['start_time'].nil?
    start_time = Time.parse(event['start_time']) unless event['start_time'].nil?
    latitude = event['place']['location']['latitude'] if event['place'] && event['place']['location']
    longitude = event['place']['location']['longitude'] if event['place'] && event['place']['location']
    private_event = (event['type'].present? && event['type'] == 'private') ? true : false
    category = event['category'].present? ? event['category'] : '#facebook'
    {
      facebook_id: event['id'],
      title: event['name'],
      description: event['description'],
      date: start_date.to_time.to_i,
      time: start_time.to_i,
      latitude: latitude,
      longitude: longitude,
      media_items: media_items(event),
      private_event: private_event,
      categories: category
    }
  end

  def media_items(event)
    image = event['cover']['source'] unless event['cover'].nil?
    if image.present?
      [
        {
          url: image,
          type: 'image'
        }
      ]
    else
      nil
    end
  end

  def events_service
    @events_service ||= EventService.new
  end

  def fields
    { fields: 'name,owner,start_time,end_time,cover,place,description' }
  end
end

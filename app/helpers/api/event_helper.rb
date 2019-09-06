module Api
  module EventHelper
    def ensure_event_is_active(event)
      ensure_event_owner_is_active(event.event_ownerable) do
        if event.active
          yield
        else
          error_response((t 'api.responses.events.suspended'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
        end
      end
    end

    def ensure_event_timeline_item_is_active(timeline_item)
      ensure_user_is_active(timeline_item.user) do
        if timeline_item.active
          yield
        else
          error_response((t 'api.responses.events.timelines.item.suspended'), Showoff::ResponseCodes::OBJECT_NOT_FOUND)
        end
      end
    end

    def ensure_event_owner_is_active(event_owner)
      if event_owner.active && !event_owner.suspended
        yield
      elsif !event_owner.active
        error_response(t('api.responses.event_owner.inactive'), Showoff::ResponseCodes::INVALID_ARGUMENT)
      elsif event_owner.suspended
        error_response(t('api.responses.event_owner.suspended'), Showoff::ResponseCodes::INVALID_ARGUMENT)
      end
    end

    def featured_objects(objects, params, user_location, limit = nil, offset = nil, user)
      return [] if objects.nil?

      objects = objects_for_filters(objects, params, user_location, limit, offset, user)
      objects = objects.starting_at_or_after(Time.now).ordered_by_popular
      objects.map { |object| { object: object.cached(user, type: :feed)} }
    end

    def objects_for_filters(objects, params, user_location, limit = nil, offset = nil, user)
      return [] if objects.nil?

      limit = limit.to_i
      limit = Api::ActiveRecord::DEFAULT_LIMIT if limit.zero?

      force_near_search = false

      bounding_box = params[:bounding_box]
      location = params[:location]
      minimum_radius = Api::ServiceConstants::Geocoder::SEARCH_DISTANCE

      if bounding_box && location
        bounding_box_distance = Geocoder::Calculations.distance_between([bounding_box[:bottom], bounding_box[:left]], [bounding_box[:top], bounding_box[:right]])
        bounding_box_radius = bounding_box_distance / 2.0

        if minimum_radius <= bounding_box_radius || params[:force_bounding_box]
          minimum_radius = bounding_box_radius
        end
      end

      if bounding_box
        bounding_objects = objects.within_bounding_box([bounding_box[:bottom], bounding_box[:left], bounding_box[:top], bounding_box[:right]])
      end

      if bounding_objects
        if bounding_objects.length < limit
          force_near_search = true

          user_location = Geocoder::Calculations.geographic_center([[bounding_box[:bottom], bounding_box[:left]], [bounding_box[:top], bounding_box[:right]]])
        else
          objects = bounding_objects
        end
      end

      if (location || user_location) && (!bounding_box || force_near_search)
        lat_lng = user_location
        lat_lng = [location[:latitude], location[:longitude]] if location

        near_objects = objects.near(lat_lng, minimum_radius)

        objects = near_objects
      end

      filters = params[:filters]

      objects = objects_for_tags(filters, objects) if filters

      search = params[:search]
      objects = objects.for_term(search[:term]) if search && search[:term].present? && objects.respond_to?(:for_term)

      objects = objects.klass.where(id: objects.uniq.map(&:id))
      objects = objects.order_to_now
      objects = objects.limit(limit) if limit
      objects = objects.offset(offset) if offset

      objects
    end

    def objects_for_tags(filters, objects)
      if filters[:tags] && objects.respond_to?(:with_tags)
        tags = filters[:tags].split('|').flatten
        objects = objects.with_tags(tags)
      end
      
      if filters[:start_at]
        objects = objects.starting_at_or_after(Time.at(filters[:start_at].to_i))
      end
      
      if filters[:end_at]
        objects = objects.ending_at_or_before(Time.at(filters[:end_at].to_i))
      end

      if filters[:contribution_type]
        objects = objects.with_contribution_type(filters[:contribution_type])
      end

      if filters[:low_price] && filters[:top_price]
        objects = objects.budget_range(filters[:low_price], filters[:top_price])
      end
      
      objects
    end
  end
end

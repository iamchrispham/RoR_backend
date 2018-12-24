module Api
  module EventHelper
    def ensure_event_is_active(event)
      ensure_user_is_active(event.user) do
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

    def featured_objects(objects, params, user_location, limit = nil, offset = nil, user)
      return [] if objects.nil?

      objects = objects_for_filters(objects, params, user_location, limit, offset, user)
      objects = objects.starting_at_or_after(Time.now).ordered_by_popular
      build_mosaic(objects, user)
    end

    def build_mosaic(objects, user)
      sizes = %i[small medium large]
      positions = %i[left right]
      size = position = previous_position = previous_size = nil
      index = 0
      size_constraints = {
        small: 3,
        medium: 3,
        large: 2
      }
      results = []
      while index < objects.length
        size = sizes.sample
        position = positions.sample
        size = sizes.sample while size != :medium && size.eql?(previous_size)
        position = positions.sample while position.eql?(previous_position)
        constraint = size_constraints[size]
        break if (index + constraint) >= objects.length
        section = objects[index..(index + constraint - 1)].map do |object|
          {
            size: size,
            object: object.cached(user, type: :feed)
          }
        end
        if size.eql?(:medium)
          section = section.map do |object|
            object[:size] = :small
            object
          end
          if position.eql?(:left)
            object = section.first
            object[:size] = size
            section[0] = object
          else
            object = section.last
            object[:size] = size
            section[section.length - 1] = object
          end
        end
        results << {
          type: "#{position}_#{size}",
          objects: section
        }
        index += size_constraints[size]
        previous_size = size
        previous_position = position
      end
      [results, index]
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

      if user.present?
        objects = objects.not_eighteen_plus unless user.eighteen_plus
        attending_events = current_api_user.possible_attending_events
      end
      objects = objects.where(private_event: false).or(objects.where(id: attending_events))

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

      objects
    end
  end
end

module Api
  module CacheHelper
    include Api::ErrorHelper

    def auto_expire_cache(duration = nil)
      @auto_expire_cache ||= AutoExpireCache.new(duration)
    end

    def cached_object(key, object_function_if_stale = nil, duration = 86_400)
      cache = auto_expire_cache(duration)

      object = cache[key]

      unless object
        cache[key] = if object_function_if_stale
                       send(object_function_if_stale)
                     else
                       yield
                     end.as_json

        object = cache[key]
      end

      JSON.parse(object)
    rescue JSON::ParserError => e
      object
      puts e.message
      puts e.backtrace
    rescue StandardError => e
      report_error(e)
      object
      puts e.message
      puts e.backtrace
    end

    def cached_collection(key, object_function_if_stale, collection_object_function_if_stale, collection_object_cache_key_function, duration = 86_400)
      cache = auto_expire_cache(duration)
      objects = cache[key]

      if objects.blank?
        object = send(object_function_if_stale)
        return [] if object.nil?
        cache[key] = object
      end

      objects = cache[key]
      objects = JSON.parse(objects)

      #check if previous value was blank and re-fetch if so
      if objects.size.zero?
        object = send(object_function_if_stale)
        return [] if object.nil?
        cache[key] = object

        objects = cache[key]
        objects = JSON.parse(objects)
      end

      collected_objects = []
      objects.each do |object|
        params = {object: object}

        cached_object = cache[send(collection_object_cache_key_function, params)]
        if cached_object.blank?

          collected_objects << send(collection_object_function_if_stale, params)
          cache[send(collection_object_cache_key_function, params)] = collected_objects.last

        else
          collected_objects << JSON.parse(cached_object)
        end
      end
      collected_objects
    rescue StandardError => e
      report_error(e)
      collected_objects
    end

    def remove_cached_object(pattern)
      auto_expire_cache.del_matching(pattern)
    end
  end
end

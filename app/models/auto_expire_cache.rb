class AutoExpireCache
  CACHE_IDENTIFIER = 'showoff_aec'

  # Cache for 1 day by default
  def initialize(ttl = 86_400)
    @ttl = ttl
    if $redis.blank?
      uri = URI.parse(ENV["REDIS_URL"])
      $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    end
  end

  def [](key)
    return nil if key.nil?

    key = id_key(key)

    value = $redis.[](key)
    $redis.expire(key, ttl) if value
    value
  end

  def []=(key, value)
    return if key.nil?

    key = id_key(key)

    $redis.[]=(key, value.to_json)
    $redis.expire(key, ttl)
  end

  def keys
    matching_keys('*')
  end

  def matching_keys(pattern)
    $redis.keys(id_key("*#{pattern}*"))
  end

  def del(*keys)
    $redis.del(*keys) unless keys.empty?
  end

  def del_matching(key)
    keys = matching_keys(key)
    del(keys) unless keys.empty?
  end

  def ttl
    @ttl ||= 86_400
  end

  def self.clear!
    cache = AutoExpireCache.new

    keys = cache.keys

    cache.del(keys) unless keys.empty?
  end

  private

  def id_key(key)
    key.start_with?(CACHE_IDENTIFIER) ? key : "#{CACHE_IDENTIFIER}_#{key}"
  end
end

# The Redis DB is used to store data to be process by the Sidekiq worker.
uri = URI.parse(ENV["REDIS_URL"])
$redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
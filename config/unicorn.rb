worker_processes 4
timeout 30
preload_app true
 
before_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end
 
  # If you are using Redis but not Resque, change this
  if defined?(Afterparty)
    Afterparty.redis.quit
    Rails.logger.info('Disconnected from Redis')
  end
 
  sleep 1
end
 
after_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    Rails.logger.info('Connected to ActiveRecord')
  end
 
  # # If you are using Redis but not Resque, change this
  if defined?(Afterparty)
    require 'open-uri'
    uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://localhost:6379")
    redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    Rails.configuration.redis = redis
    Afterparty.redis = redis
    Rails.logger.info('Connected to Redis')
  end
end
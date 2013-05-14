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
  # if defined?(Afterparty)
  #   Rails.configuration.queue.consumer.shutdown
  #   Rails.logger.info('Disconnected from Redis')
  # end
 
  sleep 1
end
 
after_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    Rails.logger.info('Connected to ActiveRecord')
  end
 
  # # If you are using Redis but not Resque, change this
  # if defined?(Afterparty)
  #   require 'open-uri'
  #   uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://localhost:6379")
  #   Rails.configuration.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  #   Rails.configuration.queue.redis = Rails.configuration.redis
  #   Rails.logger.info('Connected to Redis')
  # end
end
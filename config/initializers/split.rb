Split::Dashboard.use Rack::Auth::Basic do |username, password|
  user = User.authenticate(username, password)
  !user.nil? && user.is_admin?
end

if Rails.configuration.queue.is_a? Afterparty::Queue
  Rails.configuration.queue.config_login do |username, password|
    user = User.authenticate(username, password)
    !user.nil? && user.is_admin?
  end
end

Split.configure do |config|
  config.allow_multiple_experiments = true
  config.persistence = Split::Persistence::RedisAdapter.with_config(lookup_by: :current_user_id)
end

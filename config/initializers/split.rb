Split::Dashboard.use Rack::Auth::Basic do |username, password|
  user = User.authenticate(username, password)
  !user.nil? && user.is_admin?
end

Rails.configuration.queue.config_login do |username, password|
  user = User.authenticate(username, password)
  !user.nil? && user.is_admin?
end

Split.configure do |config|
  config.allow_multiple_experiments = true
end
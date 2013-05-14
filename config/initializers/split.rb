Split::Dashboard.use Rack::Auth::Basic do |username, password|
  user = User.authenticate(username, password)
  !user.nil? && user.is_admin?
end
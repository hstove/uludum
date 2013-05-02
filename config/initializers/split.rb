Split::Dashboard.use Rack::Auth::Basic do |username, password|
  username == 'admin' && password == 'adminpass'
end
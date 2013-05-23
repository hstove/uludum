if Rails.env.development? or Rails.env.test?
  key = ('x' * 30)
  base = ('y' * 30)
else
  key = ENV['SECRET_TOKEN']
  base = ENV['SECRET_BASE']
end

Ludum::Application.config.secret_token = key
Ludum::Application.config.secret_key_base = base
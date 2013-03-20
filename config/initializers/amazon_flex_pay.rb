AmazonFlexPay.access_key = ENV['U_AWS_ACCESS_KEY_ID']
AmazonFlexPay.secret_key = ENV['U_AWS_SECRET_KEY']
AmazonFlexPay.go_live! if Rails.env.production?
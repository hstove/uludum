# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, aliases: [:teacher] do
    username
    email
    password "password"
    sequence(:recipient_token) {|n| "token#{n}#{(rand*1000).to_i}" }
    stripe_key "sk_test_XF2SctReftg7417qgx56Iy6R"
    bitcoin_address { (0...34).map { (65 + rand(26)).chr }.join }
  end
end

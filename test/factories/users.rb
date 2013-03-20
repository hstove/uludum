# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, aliases: [:teacher] do
    username
    email
    password "password"
    sequence(:recipient_token) {|n| "token#{n}#{(rand*1000).to_i}" }
  end
end

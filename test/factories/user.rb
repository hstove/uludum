# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, aliases: [:teacher] do
    username
    email
    password "password"
  end
end

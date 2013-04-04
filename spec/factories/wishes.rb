# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wish do
    user
    title
    description "MyText"
  end
end

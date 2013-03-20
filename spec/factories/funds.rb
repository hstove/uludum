# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :fund do
    user
    body "MyText"
    price 10
    title
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :fund do
    user
    body
    price 10
    title
    goal_date { 10.days.from_now }
    goal 100.00
  end
end

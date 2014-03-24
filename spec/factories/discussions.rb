# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :discussion do
    user
    title "MyString"
    body "MyText"
  end
end

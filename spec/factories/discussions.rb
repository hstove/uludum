# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :discussion do
    course_id 1
    user_id 1
    title "MyString"
    body "MyText"
  end
end

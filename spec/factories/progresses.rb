# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :progress do
    progressable_type "MyString"
    progressable_id 1
    percent 1.5
  end
end

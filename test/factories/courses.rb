# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course do
    title
    description "A cool course"
    teacher
    category "Economics"
  end
end

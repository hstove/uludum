# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    subsection
    prompt "Tough question"
  end
end

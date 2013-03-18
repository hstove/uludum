# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    subsection
    prompt "whats up?"
  end
end

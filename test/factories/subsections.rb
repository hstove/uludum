# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subsection do
    section
    title :title
    body "My Body"
  end
end

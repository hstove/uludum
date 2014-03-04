# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :download do
    url FactoryGirl.generate(:title)
    title
    description FactoryGirl.generate(:lorem)
  end
end

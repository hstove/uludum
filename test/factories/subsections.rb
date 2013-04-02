# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subsection do
    section
    title
    body LoremIpsum::Generator.new.generate({})
  end
end

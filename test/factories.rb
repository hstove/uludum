FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :title do |n|
    "awesome title #{n}"
  end

  sequence :username do |n|
    "user#{n}"
  end

  sequence(:position) { |n| n }

  sequence :lorem do |n|
    LoremIpsum::Generator.new.generate({})
  end

  sequence :body do |n|
    LoremIpsum::Generator.new.generate({})
  end

  sequence :random do
    (0...34).map { (65 + rand(26)).chr }.join
  end
end
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

  sequence :lorem do |n|
    LoremIpsum::Generator.new.generate({})
  end
  
end
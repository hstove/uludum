# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_answer do
    user_id 1
    question_id 1
    free_answer "MyString"
    attempts 1
    last_answer_id 1
    correct false
  end
end

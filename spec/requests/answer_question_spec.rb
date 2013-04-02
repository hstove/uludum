require 'spec_helper'

describe 'answering questions', js: true do

  it "gives a hint when within 2 decimals" do
    @question = create :question
    @question.free_answer = 1.256348
    @question.save

    user = create :user
    user.enroll @question.course_id

    login user, 'password'

    visit subsection_question_path(@question.subsection, @question)
    fill_in :free_answer, with: '1.25635'
    click_on 'Submit'

    current_path.should match(subsection_question_path(@question.subsection, @question))
    page.should have_content("you were within 2 decimal places short of the answer.")
  end

  it "says you were correct when you were" do
    @question = create :question
    @question.free_answer = 1416
    @question.save

    user = create :user
    user.enroll @question.course_id

    login user, 'password'

    visit subsection_question_path(@question.subsection, @question)
    fill_in :free_answer, with: '1416.1'
    click_on 'Submit'

    page.should have_content("Question was answered correctly")
  end

  it "says you were incorrect when you were" do
    @question = create :question
    @question.free_answer = 1416
    @question.save

    user = create :user
    user.enroll @question.course_id

    login user, 'password'

    visit subsection_question_path(@question.subsection, @question)
    fill_in :free_answer, with: '1415'
    click_on 'Submit'

    page.should have_content("Question was answered incorrectly")
    current_path.should match(subsection_question_path(@question.subsection, @question))
  end

end
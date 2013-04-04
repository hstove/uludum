describe UserAnswer do
  it "updates subsection progress when correct is changed" do
    answer = create :user_answer
    question = answer.question
    question.update_attributes free_answer: "hello"
    user = answer.user
    course = question.course
    user.enroll course
    course.progress(user).percent.should == 0

    answer.correct = true
    answer.save

    question.subsection.progress(user).percent.should == 100
    question.subsection.section.progress(user).percent.should == 100
    course.progress(user).percent.should == 100
  end

end
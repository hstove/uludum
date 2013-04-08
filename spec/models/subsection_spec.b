describe Subsection do
  it "knows when a user is complete"
    sub = create :subsection
    course = sub.course
    user = create :user
    user.enroll course
    sub.complete?(user).should_not == true
  end

end
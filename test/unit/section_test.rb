require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  test "user has right auth for enrolled classes" do
    section = create :section
    course = section.course
    user = create :user
    ability = Ability.new(user)
    assert ability.cannot?(:read, section)
    user.enroll(course.id)
    assert ability.can?(:read, section)
  end
end

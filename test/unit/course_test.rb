require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  test "cannot create course without required attributes" do
    @course = Course.new
    assert !@course.save, "doesn't have a title"
    @course.title = FactoryGirl.generate(:title)
    assert !@course.save, "doesnt have a description"
    @course.description = "a cool course"
    assert !@course.save, "doesn't have a category"
    @course.category = "economics"
    assert !@course.save, "doesn't have teacher_id"
    @course.teacher_id = 1
    assert @course.save, "has required attributes"
  end

  test "teacher can do all abilities" do
    course = create :course
    teach = course.teacher
    ability = Ability.new(teach)
    assert ability.can?(:manage, course), "teacher can manage course"
  end

  test "search functionality returns correct results" do
    Course.destroy_all
    course = create :course
    course.update_attributes(title: "science project")
    assert Course.search("science").all.include? course
  end
end

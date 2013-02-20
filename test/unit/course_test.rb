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
end

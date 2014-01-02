require 'spec_helper'

describe Course do
  let(:course) { create :course }
  it "cannot create course without required attributes" do
    course = Course.new
    assert !course.save, "doesn't have a title"
    course.title = FactoryGirl.generate(:title)
    assert !course.save, "doesnt have a description"
    course.description = "a cool course"
    assert !course.save, "doesn't have a category"
    course.category = create(:category)
    assert !course.save, "doesn't have teacher_id"
    course.teacher_id = 1
    assert course.save, "has required attributes"
  end

  it "teacher can do all abilities" do
    teach = course.teacher
    ability = Ability.new(teach)
    assert ability.can?(:manage, course), "teacher can manage course"
  end

  it "search functionality returns correct results" do
    Course.destroy_all
    course = create :course
    course.update_attributes(title: "science project")
    assert Course.search("science").to_a.include? course
  end

  describe "#next_subsection" do
    it "goes to the correct next one" do
      sub = create :subsection
      section = sub.section
      course = sub.course
    end
  end

  describe "#after_save" do
    it "enrolls fund backers after a course is approved & valid" do
      fund = create :fund, course_id: course.id
      create :order, orderable: fund, user_id: new_stripe_customer.id
      course.approved = true
      course.hidden = false
      course.fund(true)
      course.fund.stubs(:ready?).returns(true)
      User.any_instance.should_receive(:enroll).with(course)
      Order.any_instance.should_receive(:complete).and_call_original
      course.save
    end

    it "doesn't enroll fund backers if fund isn't ready" do
      fund = create :fund, course_id: course.id
      create :order, orderable: fund, user_id: create(:user).id
      course.approved = true
      course.hidden = false
      course.fund(true)
      User.any_instance.should_not_receive(:enroll).with(course)
      Order.any_instance.should_not_receive(:complete).and_call_original
      course.save
    end

    it "doesn't enroll fund backers if not visible" do
      fund = create :fund, course_id: course.id
      create :order, orderable: fund, user_id: create(:user).id
      course.approved = true
      course.hidden = nil
      course.fund(true)
      User.any_instance.should_not_receive(:enroll).with(course)
      Order.any_instance.should_not_receive(:complete).and_call_original
      course.save
    end

    it "doesn't enroll fund backers if not approved" do
      fund = create :fund, course_id: course.id
      create :order, orderable: fund, user_id: create(:user).id
      course.hidden = false
      course.fund(true)
      User.any_instance.should_not_receive(:enroll).with(course)
      Order.any_instance.should_not_receive(:complete).and_call_original
      course.save
    end

    it "enrolls it's teacher on create" do
      Enrollment.enrolled?(course, course.user).should == true
    end
  end
end

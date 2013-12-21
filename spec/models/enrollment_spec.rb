require 'spec_helper'

describe Enrollment do
  let(:user) { create :user }
  let(:course) { create :course }

  describe "after_create" do
    it "emails the user after enrollment" do
      UserMailer.should_receive(:new_enrollment).with(user, course).once.and_call_original
      enrollment = user.enroll course
      enrollment.save
    end
  end

end
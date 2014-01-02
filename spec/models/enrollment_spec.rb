require 'spec_helper'

describe Enrollment do
  let(:user) { create :user }
  let(:course) { create :course }

  describe "after_create" do
    it "emails the user after enrollment" do
      enrollment = user.enroll course
      last_email.to.should include(user.email)
    end
  end

end
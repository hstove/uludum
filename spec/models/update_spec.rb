require 'spec_helper'

describe Update do
  describe "after create" do
    let(:updateable) { create :fund }
    let(:course) { create :course }
    let(:user) {
      user = create :user
      order = user.orders.build
      order.orderable = updateable
      order.price = updateable.price
      order.save!
      user
    }
    it "should send an email to all funders when an update is created" do
      update = build :update, updateable: updateable
      UserMailer.should_receive(:new_update).with(update, user).once.and_call_original
      update.save!
    end
    it "should send an email to course students" do
      update = build :update, updateable: course
      user = create :user
      user.enroll course
      UserMailer.should_receive(:new_update).twice.and_call_original
      update.save!
      last_email.to.should include(user.email)
      course.updates.should include(update)
    end
  end
end

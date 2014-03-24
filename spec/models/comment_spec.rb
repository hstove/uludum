require 'spec_helper'

describe Comment do
  let(:course) { create :course }
  let(:commentable) { create :discussion, discussable: course }
  let(:comment) { build :comment, commentable: commentable }
  before(:each) { reset_email }
  it "sends an email to commentable.user" do
    comment.save
    last_email.to.should include(commentable.user.email)
  end

  it "sends an email to other members of the discussion" do
    other_comment = create :comment, commentable: commentable
    reset_email
    comment.save
    notifier = last_email
    last_email.to.should include(other_comment.user.email)
    notifications = ActionMailer::Base.deliveries.select do |mail|
      mail.subject.include? "has a new comment"
    end
    notifications.size.should eql 2
    notifications.select do |mail|
      mail.to.first == comment.user.email
    end.size.should eql 0
  end
end
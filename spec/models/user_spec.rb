require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  def new_user(attributes = {})
    attributes[:username] ||= 'foo'
    attributes[:email] ||= 'foo@example.com'
    attributes[:password] ||= 'abc123'
    attributes[:password_confirmation] ||= attributes[:password]
    User.new(attributes)
  end

  before(:each) do
    User.delete_all
  end

  it "should be valid" do
    new_user.should be_valid
  end

  it "should require username" do
    new_user(:username => '').should have(1).error_on(:username)
  end

  it "should require password" do
    new_user(:password => '').should have(1).error_on(:password)
  end

  it "should require well formed email" do
    new_user(:email => 'foo@bar@example.com').should have(1).error_on(:email)
  end

  it "should validate uniqueness of email" do
    new_user(:email => 'bar@example.com').save!
    new_user(:email => 'bar@example.com').should have(1).error_on(:email)
  end

  it "should validate uniqueness of username" do
    new_user(:username => 'uniquename').save!
    new_user(:username => 'uniquename').should have(1).error_on(:username)
  end

  it "should not allow odd characters in username" do
    new_user(:username => 'odd ^&(@)').should have(1).error_on(:username)
  end

  it "should validate password is longer than 3 characters" do
    new_user(:password => 'bad').should have(1).error_on(:password)
  end

  it "creates a user with less points than the activation points" do
    user = create :user
    user.points.should < User::ACTIVATION_POINTS
  end

  it "correctly states whether a user is activated" do
    user = create :user
    user.activated?.should == false
    3.times do
      course = create :course
      user.enroll course
    end
    user.activated?.should == true
  end

  it "marks a user as accepted if they've funded something" do
    user = new_stripe_customer
    order = build :order
    fund = create :fund
    order.orderable = fund
    order.user = user

    order.save
    user.reload
    user.activated?.should == true
  end

  # it "should require matching password confirmation" do
  #   user = new_user(:password_confirmation => 'nonmatching')
  #   user.save
  #   user.should have(1).error_on(:password)
  # end

  it "should generate password hash and salt on create" do
    user = new_user
    user.save!
    user.password_hash.should_not be_nil
    user.password_salt.should_not be_nil
  end

  it "should authenticate by username" do
    user = new_user(:username => 'foobar', :password => 'secret')
    user.save!
    User.authenticate('foobar', 'secret').should == user
  end

  it "should authenticate by email" do
    user = new_user(:email => 'foo@bar.com', :password => 'secret')
    user.save!
    User.authenticate('foo@bar.com', 'secret').should == user
  end

  it "should not authenticate bad username" do
    User.authenticate('nonexisting', 'secret').should be_nil
  end

  it "should not authenticate bad password" do
    new_user(:username => 'foobar', :password => 'secret').save!
    User.authenticate('foobar', 'badpassword').should be_nil
  end

  it "should send a welcome email on create" do
    user = create :user
    body = last_email.body.encoded
    body.should match(user.username)
    body.should match("http://www.uludum.org")
    last_email.to.should include(user.email)
    last_email.bcc.should include("hstove@gmail.com")
  end

  it "should create drip emails on create"# do
  #   @user, @jobs = nil, nil
  #   lambda {
  #     @user = create :user
  #   }.should change {(@jobs = Rails.configuration.queue.jobs).size }.by(2)
  #   included_personal_mailer = false
  #   included_feedback_mailer = false
  #   @jobs.each do |job_container|
  #     job = job_container.reify
  #     ap job
  #     ap job_container
  #     if job.job_class == UserMailer && job.method == :personal && job.args == [@user]
  #       (job.execute_at - Time.now).should > 25.minutes
  #       included_personal_mailer = true
  #     elsif job.job_class == UserMailer && job.method == :feedback_or_remind && job.args == [@user]
  #       (job.execute_at - Time.now).should > 13.days
  #       included_feedback_mailer = true
  #     end
  #   end
  #   included_personal_mailer.should eq(true), "jobs queue should include personal mailer"
  #   included_feedback_mailer.should eq(true), "jobs queue should include feedback mailer"
  # end

  it "user#enrolled_courses includes hidden courses" do
    user = create :user
    course = create :course, hidden: true
    user.enroll(course)
    user.enrolled_in.should include(course)
  end

  it "adds courses when enrolled" do
    user = create :user
    course = create :course
    user.enroll(course)
    user.enrolled_in.should include(course)
  end

  describe "#send_password_reset" do
    let(:user) { create(:user) }

    it "generates a unique password_reset_token each time" do
      user.send_password_reset
      last_token = user.password_reset_token
      user.send_password_reset
      user.password_reset_token.should_not eql(last_token)
    end

    it "saves the time the password reset was sent" do
      user.send_password_reset
      user.reload.password_reset_sent_at.should be_present
    end

    it "delivers email to user" do
      user.send_password_reset
      last_email.to.should include (user.email)
    end
  end
end

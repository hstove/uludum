require "spec_helper"

describe UserMailer do
  #pending "add some examples to (or delete) #{__FILE__}"

  it "requests skills when people want them" do
    user = create :user
    note = generate(:lorem).gsub("\n","")
    wish = create(:wish)
    email = generate(:email)
    mail = UserMailer.request_skills(user, email, wish, note)
    mail.to.should eq([email])
    mail.subject.should eq("Your skills have been requested on uludum.org")
    mail.from.should eq(["info@uludum.org"])
    mail.body.encoded.should match(note)
    mail.body.encoded.should match(wish.title)
    mail.body.encoded.should match(user.email)
  end

  it "sends a personal email from hank" do
    user = create :user
    mail = UserMailer.personal(user)
    mail.content_type.should include("text/plain")
    mail.from.should eq(["hstove@gmail.com"])
    mail.body.encoded.should include(user.username)
  end

  it "reminds an unactivated user" do
    user = create :user
    mail = UserMailer.feedback_or_remind(user)
    mail.subject.downcase.should include("come back")
    mail.body.encoded.should include("didn't get much use")
  end

  it "asks for feedback from activated user" do
    user = create :user
    3.times do
      course = create :course
      user.enroll course
    end
    mail = UserMailer.feedback_or_remind(user)
    mail.subject.downcase.should include("how do you like uludum")
    mail.body.encoded.should include("you've already been active")
  end

  describe "password_reset" do
    let(:user) { create(:user, :password_reset_token => "anything") }
    let(:mail) { UserMailer.password_reset(user) }

    it "sends user password reset url" do
      mail.subject.should eq("Password reset instructions")
      mail.to.should eq([user.email])
      mail.from.should eq(["info@uludum.org"])
    end

    it "renders the body" do
      mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
    end
  end
end

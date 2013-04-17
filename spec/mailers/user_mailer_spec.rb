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
end

class UserMailer < ActionMailer::Base
  default from: "info@uludum.org"

  def welcome_email(user)
    @user = user
    mail(to: user.email, subject: "Welcome to Uludum!", cc: "info@uludum.org")
  end
end

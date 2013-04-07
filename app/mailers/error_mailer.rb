class ErrorMailer < ActionMailer::Base
  default from: "info@uludum.org"
  default to: "hstove@gmail.com"
  default subject: "Error report from Uludum"

  def error(message, user=nil)
    @message = message
    @user = user
    mail()
  end
end

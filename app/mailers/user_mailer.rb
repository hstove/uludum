class UserMailer < ActionMailer::Base
  default from: "info@uludum.org"

  def welcome_email(user)
    @user = user
    mail(to: user.email, subject: "Welcome to Uludum!", cc: "info@uludum.org")
  end

  def order_complete(order)
    @user = order.user
    @order = order
    mail(subject: "Your Uludum order is complete.", to: @user.email)
  end

  def order_processing(order)
    @user = order.user
    @order = order
    mail(subject: "Your Uludum order is processing.", to: @user.email)
  end
end

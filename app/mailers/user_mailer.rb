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

  def new_seller_order(order)
    @user = order.orderable.user
    @order = order
    mail(subject: "You have a new order for #{@order.orderable.title}", to: @user.email)
  end

  def seller_order_complete(order)
    @user = order.orderable.user
    @order = order
    mail(subject: "Payment complete for #{@order.orderable.title}", to: @user.email)
  end

  def order_processing(order)
    @user = order.user
    @order = order
    mail(subject: "Your Uludum order is processing.", to: @user.email)
    new_seller_order(order)
  end
end

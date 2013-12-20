class UserMailer < ActionMailer::Base
  default from: "info@uludum.org"
  # default bcc: "hstove@gmail.com"
  add_template_helper(ApplicationHelper)
  add_template_helper(ShareHelper)
  layout nil, except: :personal

  def welcome_email(user)
    @user = user
    mail(to: user.email, subject: "Welcome to Uludum!")
  end

  def order_complete(order)
    self.class.seller_order_complete(order).deliver if order.orderable.class == Course
    @user = order.user
    @order = order
    mail(subject: "Your Uludum order is complete.", to: @user.email)
  end

  def order_processing(order)
    self.class.new_seller_order(order).deliver
    @user = order.user
    @order = order
    mail(subject: "Your Uludum order is processing.", to: @user.email)
  end

  def new_seller_order(order)
    @user = order.orderable.user
    @order = order
    mail(subject: "You have a new payment processing for #{@order.orderable.title}", to: @user.email)
  end

  def seller_order_complete(order)
    @user = order.orderable.user
    @order = order
    mail(subject: "Payment complete for #{@order.orderable.title}", to: @user.email)
  end

  def request_skills(user, email, wish, note=nil)
    @note = note
    @email = email
    @from_user = user
    @wish = wish
    mail(subject: "Your skills have been requested on uludum.org", to: @email)
  end

  def new_enrollment(user, course)
    @user = user
    @course = course
    mail(to: @user.email, subject: "You've successfully enrolled in #{course.title}")
  end

  def personal user
    @user = user
    mail(to: @user.email, from: "hstove@gmail.com", subject: "Personal hello from Uludum")
  end

  # run in 2 weeks. if user.activated? ask for feedback, else
  # remind the user
  def feedback_or_remind user
    @user = user
    @activated = @user.activated?
    subject = @activated ? "How do you like Uludum?" : "Come back to Uludum"
    mail(to: @user.email, subject: subject)
  end

  def new_teacher course
    @user = course.teacher
    @course = course
    mail(to: @user.email, subject: "Thanks for creating your first course")
  end

  def get_approval fund
    @fund = fund
    @course = fund.course
    mail(to: "hstove@gmail.com", subject: "A fund has added a course and needs approval.")
  end

  def new_comment new_comment
    @comment = new_comment
    @commentable = new_comment.commentable
    subject = "#{@commentable.title} has a new comment."
    mail(to: @commentable.user.email, subject: subject)
  end

  def password_reset user
    @user = user
    mail :to => user.email, :subject => "Password reset instructions"
  end

end

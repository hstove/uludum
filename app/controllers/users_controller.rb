class UsersController < ApplicationController
  before_filter :login_required, :except => [:new, :create, :show, :index]

  def index
    @users = User.order("created_at desc")
  end

  def new
    @user = User.new
  end

  def create
    return_to = params[:user][:return_to]
    @user = User.new(params[:user].except(:return_to))
    if @user.save
      session[:user_id] = @user.id
      redirect_to how_to_use_path(return_to: return_to), :notice => "Thank you for signing up! You are now logged in."
    else
      render :action => 'new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    authorize! :update, @user
    if @user.update_attributes(params[:user].except(:return_to))
      redirect_to edit_user_path, :notice => "Your profile has been updated."
    else
      render :action => 'edit'
    end
  end
 
  def show
    @user = User.find(params[:id])
  end

  def payment

  end

  def prefill
    begin
      if current_user.stripe_customer_id.nil?
        customer = Stripe::Customer.create(
          card: params[:stripeToken],
          description: current_user.username,
          email: current_user.email
        )
        current_user.stripe_customer_id = customer.id
        current_user.save
      else
        customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
        customer.card = params[:stripeToken]
        customer.save
      end
      flash[:notice] = "You have successfully configured your payment information"
      if params[:return_to]
        redirect_to params[:return_to]
        return
      end
      redirect_to payment_path
    rescue Stripe::StripeError => e
      redirect_to payment_path, alert: "There was an error configuring your payment options. #{e.message}"
    end
  end

  def postfill
    if params[:status] == "SR"
      @user = current_user
      @user.recipient_token = params["tokenID"]
      @user.refund_token = params["refundTokenID"]
      @user.save
      redirect_to @user, notice: "You have successfully configured your payment information."
    else
      redirect_to current_user, alert: "We were unable to configure your payment information."
    end
  end

  def test_email
    if Rails.env.development?
      # UserMailer.welcome_email(User.find(1)).deliver
      order = Order.find(11)
      # UserMailer.order_processing(order).deliver
      # UserMailer.order_complete(order).deliver
      UserMailer.request_skills(User.find(1), "test@test.com", Wish.first, "This is a note").deliver
    end
    render text: "sent email"
  end

  def request_skills
    @wish = Wish.find(params[:wish_id])
    if params[:email].nil? || params[:email].empty?
      redirect_to @wish, alert: "You must enter an email when sharing this course."
      return
    end
    UserMailer.request_skills(current_user, params[:email], @wish, params[:note]).deliver
    redirect_to @wish, notice: "You've successfully requested #{params[:email]}'s skills"
  end

end


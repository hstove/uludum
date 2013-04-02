class UsersController < ApplicationController
  before_filter :login_required, :except => [:new, :create, :show]

  def new
    @user = User.new
  end

  def create
    return_to = params[:user][:return_to]
    @user = User.new(params[:user].except(:return_to))
    if @user.save
      session[:user_id] = @user.id
      next_url = return_to || root_url
      redirect_to next_url, :notice => "Thank you for signing up! You are now logged in."
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

  def prefill
    port = Rails.env.production? ? "" : ":3000"
    callback_url = "#{request.scheme}://#{request.host}#{port}/users/payment_postfill"
    amazon_opts = {recipient_pays_fee: true}
    amazon_opts[:max_variable_fee] = 5 unless Rails.env.development?
    redirect_to AmazonFlexPay.recipient_pipeline(SecureRandom.uuid, callback_url, amazon_opts)
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
end


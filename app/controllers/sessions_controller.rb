class SessionsController < ApplicationController
  before_filter :login_required, only: [:oauth]
  def new
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      persist_login(user)
      next_url = params[:return_to] || root_url
      user.last_login = Time.now
      # user.delay.save
      user.save
      redirect_to_target_or_default next_url, :notice => "Logged in successfully."
    else
      flash.now[:alert] = "Invalid login or password."
      render :action => 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "You have been logged out."
  end

  def oauth
    auth_hash = request.env['omniauth.auth']
    flash[:notice] = "You have successfully set up your #{auth_hash["provider"].titleize} settings."
    if auth_hash["provider"] == "stripe_connect" && auth_hash["credentials"]
      track "stripe connect"
      stripe_key = auth_hash["credentials"]["token"]
      current_user.stripe_key = stripe_key
      current_user.save
      redirect_to payment_path
      return
    end
    redirect_to edit_current_user_path
  end
end

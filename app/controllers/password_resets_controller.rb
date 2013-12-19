class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by!(email: params[:email])
    user.send_password_reset
    redirect_to :root, :notice => "An email has been sent with password reset instructions."
  end

  def edit
    @reset_token = params[:id]
  end
end

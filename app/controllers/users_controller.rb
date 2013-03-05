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
    if @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Your profile has been updated."
    else
      render :action => 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
    redirect_to courses_path unless logged_in?
  end
end

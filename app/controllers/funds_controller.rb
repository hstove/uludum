class FundsController < ApplicationController
  before_filter :login_required, except: [:show, :index, :how]

  def index
    if params[:created] && logged_in?
      @funds = current_user.funds
    else
      @funds = Fund.visible.open
    end
  end

  def new
    @fund = current_user.funds.new
    authorize! :manage, @fund
  end

  def create
    @fund = current_user.funds.create(params[:fund])
    authorize! :manage, @fund

    redirect_to @fund
  end

  def show
    @fund = Fund.find(params[:id])
    authorize! :read, @fund
  end

  def edit
    @fund = Fund.find(params[:id])
    authorize! :manage, @fund
  end

  def update
    @fund = Fund.find(params[:id])
    authorize! :manage, @fund
    if @fund.update_attributes(params[:fund])
      flash[:notice] = "Your fund was successfully updated."
      redirect_to @fund
    else
      flash[:alert] = "There was an error upating your request."
      redirect_to edit_fund_path(@fund)
    end
  end

  def destroy
    @fund = Fund.find(params[:id])
    authorize! :manage, @fund
    @fund.destroy
    redirect_to funds_path, notice: "Your fund was successfully destroyed."
  end

  def how
  end



end

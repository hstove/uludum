class FundsController < ApplicationController
  before_filter :login_required, except: [:show, :index]

  def index
    if params[:created]
      @funds = current_user.funds
    else
      @funds = Fund.visible
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



end

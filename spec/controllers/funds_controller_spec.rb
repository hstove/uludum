require 'spec_helper'

describe FundsController do
  def valid_session
    {
      user_id: @fund.user_id
    }
  end

  before :each do
    @user = create :user
    @fund = create :fund
  end

  it "assings the fund to the current user on #new" do
    get :new, {}, valid_session
    assigns(:fund).user.should eq(@fund.user)
  end

  describe "Funds#create" do
    it "creates with correct attributes" do
      fund_params = {fund: {title: @fund.title, body: @fund.body}}
      post :create, fund_params, valid_session
      @fund2 = assigns(:fund)
      response.should redirect_to(@fund2)
      @fund2.user_id.should eq(@fund.user_id)
      @fund2.title.should eq(@fund.title)
      @fund2.body.should eq(@fund.body)
    end
  end

end

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
    @attrs = valid_attributes
  end

  def valid_attributes
    {
      title: generate(:title),
      body: generate(:lorem)
    }
  end

  def fund_params
    {fund: valid_attributes}
  end

  it "assings the fund to the current user on #new" do
    get :new, {}, valid_session
    assigns(:fund).user.should eq(@fund.user)
  end

  describe "Funds#create" do
    it "creates with correct attributes" do 
      post :create, {fund: @attrs}, valid_session
      @fund2 = assigns(:fund)
      response.should redirect_to(@fund2)
      # @fund2.user_id.should eq(@fund.user_id)
      @fund2.title.should eq(@attrs[:title])
      @fund2.body.should eq(@attrs[:body])
    end

    it "doesn't allow if logged out" do
      post :create, fund_params
      response.redirect_url.should match(signup_path)
    end
  end

  describe "Funds#index" do
    it "assigns all funds as @funds" do
      fund = create :fund, hidden: false
      get :index, {}
      assigns(:funds).should eq([fund])
    end

    it "doesn't show hidden funds" do
      fund = create :fund
      fund.hidden = true
      fund.save
      get :index, {}
      assigns(:funds).should eq([])
    end

    it "doesn't show unopen funds" do
      fund = create :fund
      fund.hidden = false
      fund.goal_date = 2.days.ago
      fund.save
      get :index, {}
      assigns(:funds).should eq([])
    end

    it "shows enrolled funds with :created param" do
      fund = create :fund, hidden: true
      get :index, {created: true}, {user_id: fund.user_id}
      assigns(:funds).should include(fund)
    end
  end

end

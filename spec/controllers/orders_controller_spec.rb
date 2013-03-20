require 'spec_helper'

describe OrdersController do
  def valid_params
    {
      fund_id: @fund.id,
      user_id: @user.id
    }
  end

  def valid_session
    {
      user_id: @user.id
    }
  end

  before :each do
    @fund = create :fund
    @user = create :user
  end

  it "redirects to amazon on prefill" do
    get :create, valid_params, valid_session
    response.redirect_url.should match("amazon")
  end

  it "should redirect to login if user is not logged in and authorized" do
    get :create, valid_params, nil
    response.redirect_url.should match(login_path)
  end
end

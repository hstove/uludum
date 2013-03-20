require 'spec_helper'

describe Order do
  before :each do
    @fund = create :fund
    @user = create :user
    # @order = create :order
  end

  it "sets the same price as orderable" do
    order = Order.prefill!(@fund, @user)
    order.price.should eq(@fund.price)
  end

  it "should save association to user on prefill" do
    Order.prefill!(@fund, @user).user.should eq(@user)
  end

  it "should have uuid on prefill" do
    Order.prefill!(@fund, @user).should_not be(nil)
  end
end

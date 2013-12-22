require 'spec_helper'

describe Order do
  before :each do
    @fund = create :fund
    @user = create :user
    @order = build :order
    # @order = create :order
  end

  # it "sets the same price as orderable" do
  #   order = Order.prefill!(@fund, @user)
  #   order.price.should eq(@fund.price)
  # end

  # it "should save association to user on prefill" do
  #   Order.prefill!(@fund, @user).user.should eq(@user)
  # end

  # it "should have uuid on prefill" do
  #   Order.prefill!(@fund, @user).should_not be(nil)
  # end

  it "creates a stripe customer" do
    user = new_stripe_customer
    user.stripe_customer_id.should_not be_nil
    Stripe::Customer.retrieve(user.stripe_customer_id).should_not be_nil
  end

  describe "#complete" do
    it "returns true is order is already paid" do
      @order.orderable = @fund
      @order.paid = true
      @order.should_not_receive(:save!)
      @order.complete.should eq(true)
    end

    it "charges the stripe customer" do
      @order.orderable = @fund
      user = @order.user = new_stripe_customer
      @order.complete
      # Stripe::Token.stub(:create) { "token" }
      # Stripe::Charge.stub(:create) { "charge" }
      Stripe::Charge.all(customer: user.stripe_customer_id).data.size.should eq(1)
      @order.paid.should == true
    end
  end

  describe "#order_fee" do
    it "charges application fee normally" do
      @order.price = 1
      @order.order_fee.should == 100 * Order::APPLICATION_FEE
    end

    it "charges the fail fee when specified" do
      @order.price = 1
      @order.order_fee(true).should == 100 * (Order::APPLICATION_FEE + Order::FAIL_FEE)
    end
  end

  describe "before save hooks" do
    it "sets the price to fund price if orderable === Fund" do
      fund = create :fund, price: 50
      @order.orderable = fund
      @order.save
      @order.reload

      @order.price.should eq(50)
    end
  end

  describe "after save hooks" do

    it "completes the order if the ordeable is a course" do
      @order.orderable = create :course
      @order.should_receive(:complete)
      @order.save
    end

    it "sends 'order complete' mailer when paid" do
      reset_email
      course = create :course
      @order.paid = true
      @order.orderable = course
      @order.should_receive(:autoenroll)
      @order.save
      UserMailer.deliveries[0].to.should include(course.user.email)
      last_email.to.should include(@order.user.email)
    end

    it "sends 'order processing' when not paid and new" do
      reset_email
      fund = create :fund
      order = build :order
      order.orderable = fund
      order.save
      UserMailer.deliveries[0].to.should include(fund.user.email)
      last_email.to.should include(order.user.email)
    end

    it "completes the order if fund is ready" do
      fund = create :fund
      fund.stubs(:ready?).returns(true)
      @order.orderable = fund
      @order.should_receive(:complete)
      @order.save
    end

    it "finished fund orders if fund newly complete" do
      fund = create :fund, goal: 100
      @order.price = 100
      fund.course = create :course, hidden: false, approved: true
      fund.save
      ap @order.price
      @order.orderable = fund
      @order.orderable.should_receive(:finish_orders)
      @order.save
    end
  end

  describe "#autoenroll" do
    it "enrolls in a course if paid enough" do
      @order.price = 15
      course = create :course, price: 10
      @order.orderable = course
      @order.user.should_receive(:enroll).with course
      @order.send(:autoenroll)
    end

    it "doesn't enroll if not paid enough" do
      @order.price = 5
      course = create :course, price: 10
      @order.orderable = course
      @order.user.should_not_receive :enroll
      @order.send(:autoenroll)
    end

    it "enrolls in course if orderable === Fund and course approved and paid" do
      course = create :course, price: 5, approved: true
      @fund.course = course
      @order.orderable = @fund
      @order.price = 15
      @order.user.should_receive(:enroll).with course
      @order.send(:autoenroll)
    end

    it "doesn't enrolls in course if orderable === Fund and course approved and not paid" do
      course = create :course, approved: true, price: 10
      @fund.course = course
      @order.orderable = @fund
      @order.price = 5
      @order.user.should_not_receive :enroll
      @order.send(:autoenroll)
    end

    it "doesn't enrolls in course if orderable === Fund and course unapproved and paid" do
      course = create :course, price: 10
      @fund.course = course
      @order.orderable = @fund
      @order.price = 15
      @order.user.should_not_receive :enroll
      @order.send(:autoenroll)
    end
  end
end

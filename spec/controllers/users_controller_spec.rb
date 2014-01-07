require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  # render_views

  # before :each do
  #   @user = create :user
  # end

  # it "new action should render new template" do
  #   get :new
  #   response.should render_template(:new)
  # end

  # it "create action should render new template when model is invalid" do
  #   User.any_instance.stubs(:valid?).returns(false)
  #   post :create
  #   response.should render_template(:new)
  # end

  # it "create action should redirect when model is valid" do
  #   User.any_instance.stubs(:valid?).returns(true)
  #   post :create
  #   response.should redirect_to(root_url)
  #   session['user_id'].should == assigns['user'].id
  # end

  # it "edit action should redirect when not logged in" do
  #   get :edit, :id => "ignored"
  #   response.should redirect_to(login_url)
  # end

  # it "edit action should render edit template" do
  #   @controller.stubs(:current_user).returns(@user)
  #   get :edit, :id => "ignored"
  #   response.should render_template(:edit)
  # end

  # it "update action should redirect when not logged in" do
  #   put :update, :id => "ignored"
  #   response.should redirect_to(login_url)
  # end

  # it "update action should render edit template when user is invalid" do
  #   @controller.stubs(:current_user).returns(@user)
  #   User.any_instance.stubs(:valid?).returns(false)
  #   put :update, :id => "ignored"
  #   response.should render_template(:edit)
  # end

  # it "update action should redirect when user is valid" do
  #   @controller.stubs(:current_user).returns(@user)
  #   User.any_instance.stubs(:valid?).returns(true)
  #   put :update, :id => "ignored"
  #   response.should redirect_to(root_url)
  # end

  it "sends email when requesting skills" do
    reset_email
    user = create :user
    email = generate(:email)
    wish = create :wish
    get :request_skills, {email: email, note: "This is a note", wish_id: wish.id}, { user_id: user.id }
    last_email.to.should include(email)
    last_email.subject.downcase.should match("your skills have been requested")
    last_email.body.encoded.should match(user.email)
    last_email.body.encoded.should match("This is a note")
    last_email.body.encoded.should match(wish.title)
  end

  it "doesn't send email if email is null" do
    user = create :user
    email = generate(:email)
    wish = create :wish
    reset_email
    get :request_skills, {wish_id: wish.id}, { user_id: user.id }
    last_email.should be_nil
  end

  describe "change_password" do
    before :each do
      @user = create :user
      @user.send(:generate_token, :password_reset_token)
      @user.save!
    end
    let(:params) {
      {
        password_reset_token: @user.password_reset_token,
        password: "testtest",
        password_confirmation: "testtest",
      }
    }

    it "changes the password if token is right" do
      post :change_password, params
      User.authenticate(@user.email, "testtest").should eql(@user)
    end

    it "doesn't change password if token is wrong" do
      params.delete(:password_reset_token)
      expect{post :change_password, params}.to raise_error
      User.authenticate(@user.email, "testtest").should_not eql(@user)
    end
  end

  describe "#update_recipient" do
    let(:name) { FactoryGirl.generate(:email) }
    let(:account_number) { FactoryGirl.generate(:random) }
    let(:routing_number) { FactoryGirl.generate(:random) }
    let(:params) {
      {
        name: name,
        type: "individual",
        account_number: account_number,
        routing_number: routing_number,
      }
    }
    let(:user) { create :user }
    it "should create a new stripe recipient" do
      Stripe::Recipient.should_receive(:create) do
        Hashie::Mash.new({id: FactoryGirl.generate(:random)})
      end.with({
        name: name,
        type: "individual",
        bank_account: {
          country: "US",
          routing_number: routing_number,
          account_number: account_number,
        },
        email: user.email,
        description: user.username,
      })
      post :update_recipient, params, user_id: user.id
    end

    it "updates the existing recipient" do
      user.recipient_id = FactoryGirl.generate(:random)
      user.save
      stripe_recipient = Hashie::Mash.new({save: true, bank_account: nil})
      Stripe::Recipient.should_receive(:retrieve) { stripe_recipient }
      stripe_recipient.should_receive(:bank_account=)
      stripe_recipient.should_receive(:save)
      post :update_recipient, params, user_id: user.id
    end
  end

end

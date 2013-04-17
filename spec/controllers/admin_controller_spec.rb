require 'spec_helper'

describe AdminController do

  describe "GET 'dashboard'" do
    it "returns http success when admin" do
      user = create :user, admin: true
      get 'dashboard', nil, {user_id: user.id}
      response.should be_success
    end


    it "fails unless admin" do
      user = create :user
      get 'dashboard', nil, {user_id: user.id}
      response.should_not be_success
      get 'dashboard'
      response.should_not be_success
    end
  end

end

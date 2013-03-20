require 'spec_helper'

describe UsersController do
  it "sets token on postfill" do
    user = create :user
    get :postfill, {callerReference: user.id, status: "SR", tokenId: "tokenDaily"}, {user_id: user.id}
    user.reload
    user.recipient_token.should eq("tokenDaily")
  end
end

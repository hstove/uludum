require 'spec_helper'

describe WishVote do
  it "can't be made twice for same user and class" do
    vote = create :wish_vote
    vote2 = WishVote.new(user_id: vote.user_id, wish_id: vote.wish_id)
    vote2.save.should be(false)
  end
end

class WishVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :wish

  validates_presence_of :user_id, :wish_id
  attr_accessible :user_id, :wish_id
  validates_uniqueness_of :user_id, scope: :wish_id
end

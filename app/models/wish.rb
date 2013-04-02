class Wish < ActiveRecord::Base
  validates_presence_of :user_id, :title
  has_many :comments, as: :commentable
  has_many :wish_votes
  has_many :voted_users, through: :wish_votes, source: :user
  belongs_to :user

  attr_accessible :user_id, :title, :description

  after_create do |wish|
    vote = wish.user.wish_votes.create(wish_id: wish.id)
    wish
  end
end

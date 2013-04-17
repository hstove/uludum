class Wish < ActiveRecord::Base
  validates_presence_of :user_id, :title
  has_many :comments, as: :commentable
  has_many :wish_votes
  has_many :voted_users, through: :wish_votes, source: :user
  belongs_to :user
  scope :by_score, -> { all.sort_by {|w| w.score} }

  attr_accessible :user_id, :title, :description

  after_create do |wish|
    vote = wish.user.wish_votes.create(wish_id: wish.id)
    wish
  end

  def score
    hours_ago = ((Time.now - created_at) / 1.hour).round
    (wish_votes.count) / ((hours_ago + 2)**1.8)
  end

  def willingness_to_pay
    wish_votes.average(:willingness_to_pay)
  end
end

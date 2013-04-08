class Discussion < ActiveRecord::Base
  acts_as_taggable
  belongs_to :discussable, polymorphic: :true
  belongs_to :user
  has_many :comments, as: :commentable

  attr_accessible :user_id, :title, :body
end

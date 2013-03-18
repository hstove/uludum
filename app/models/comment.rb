class Comment < ActiveRecord::Base
  attr_accessible :user_id, :body
  belongs_to :commentable, polymorphic: true
  belongs_to :user
end

class Comment < ActiveRecord::Base
  attr_accessible :user_id, :body
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  after_save do
    if id_changed?
      UserMailer.new_comment(self).deliver
    end
  end
end

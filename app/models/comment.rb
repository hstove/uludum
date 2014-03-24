class Comment < ActiveRecord::Base
  attr_accessible :user_id, :body
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  validates_presence_of :body, :user_id, :commentable_id, :commentable_type

  after_create do
    job = Afterparty::MailerJob.new UserMailer, :new_comment, self
    Rails.configuration.queue << job
    if Discussion === commentable
      users = commentable.comments.map(&:user)
      users.each do |user|
        mailer UserMailer, :new_comment, self, user
      end
    end
  end
end

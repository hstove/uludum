class Enrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  validates_uniqueness_of :user_id, scope: :course_id

  attr_accessible :course_id, :user_id

  after_create do
    job = Afterparty::MailerJob.new UserMailer, :new_enrollment, user, course
    Rails.configuration.queue << job
  end
end

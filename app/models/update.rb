class Update < ActiveRecord::Base
  attr_accessible :title, :body
  belongs_to :updateable, polymorphic: true

  after_create :send_updates

  def send_updates
    users = case updateable_type
    when "Fund"
      updateable.backers
    when "Course"
      updateable.enrolled_students
    end
    users.each do |user|
      job = Afterparty::MailerJob.new UserMailer, :new_update, self, user
      Rails.configuration.queue << job
    end if users
  end
end

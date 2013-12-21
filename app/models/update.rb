class Update < ActiveRecord::Base
  attr_accessible :title, :body
  belongs_to :updateable, polymorphic: true

  after_create :send_updates

  def send_updates
    if updateable_type == "Fund"
      updateable.backers.each do |user|
        job = Afterparty::MailerJob.new UserMailer, :new_update, self, user
        Rails.configuration.queue << job
      end
    end
  end
end

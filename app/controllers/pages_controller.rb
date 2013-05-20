class PagesController < ApplicationController
  def show
    page = params[:template]
    track "visit #{page} page" unless page == "about"
    # Rails.configuration.queue << TestJob.new(Time.now + 1.hour)
    # mailer_job = Afterparty::MailerJob.new UserMailer, :welcome_email, User.find(1)
    # mailer_job.execute_at = Time.now + 1.hour
    # Rails.configuration.queue << mailer_job
    render page
  end
end

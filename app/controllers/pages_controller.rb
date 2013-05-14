class PagesController < ApplicationController
  def show
    page = params[:template]
    track "visit #{page} page" unless page == "about"
    # Rails.configuration.queue << TestJob.new
    render page
  end

  class TestJob
    attr_accessor :execute_at
    def initialize
      @mail = UserMailer.welcome_email(User.find(1))
      @execute_at = Time.now + 1.minute
    end
    
    def run
      @mail.deliver
      ap "running a job!"
    end
  end
end

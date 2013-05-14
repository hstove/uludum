class PagesController < ApplicationController
  def show
    page = params[:template]
    track "visit #{page} page" unless page == "about"
    Rails.configuration.queue << TestJob.new
    render page
  end

  class TestJob
    attr_accessor :execute_at
    def initialize
      @execute_at = Time.now + 10.seconds
    end
    
    def run
      ap "running a job!"
    end
  end
end

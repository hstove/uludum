class PagesController < ApplicationController
  def show
    page = params[:template]
    track "visit #{page} page" unless page == "about"
    Rails.configuration.queue << TestJob.new#(Time.now + 1.hour)
    render page
  end
end

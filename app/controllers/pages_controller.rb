class PagesController < ApplicationController
  def show
    page = params[:template]
    track "visit #{page} page" unless page == "about"
    render page
  end
end

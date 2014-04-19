class PagesController < ApplicationController
  def show
    page = params[:template]
    track "visit #{page} page"
    render page
  end
end

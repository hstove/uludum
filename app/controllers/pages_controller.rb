class PagesController < ApplicationController
  def show
    track "visit page", name: params[:template]
    render params[:template]
  end
end

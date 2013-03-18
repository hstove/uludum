class PagesController < ApplicationController
  def show
    render params[:template]
  end
end

class RaterController < ApplicationController

  def create
    if logged_in?
      obj = params[:klass].classify.constantize.find(params[:id])
      if enrolled? obj, current_user
        obj.rate params[:score].to_i, current_user, params[:dimension]
      end

      render :json => true
    else
      render :json => false
    end
  end

end

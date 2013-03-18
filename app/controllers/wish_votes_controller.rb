class WishVotesController < ApplicationController
  def create
    vote = WishVote.find_or_create_by(wish_id: params[:wish_id], user_id: current_user.id)
    redirect_to wish_path(params[:wish_id]), notice: 'Your wish was successfully created.'
  end
end

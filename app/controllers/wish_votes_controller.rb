class WishVotesController < ApplicationController
  before_filter :login_required
  
  def create
    vote = WishVote.find_or_create_by(wish_id: params[:wish_id], user_id: current_user.id)
    redirect_to wish_path(params[:wish_id]), notice: 'Your wish was successfully created.'
  end

  def update
    @wish_vote = WishVote.find(params[:id])
    authorize! :update, @wish_vote
    if @wish_vote.update_attributes(params[:wish_vote])
      flash[:notice] = "Thanks for letting us know what you think!"
    else
      flash[:alert] = "There was an error updating your vote"
    end
    redirect_to @wish_vote.wish
  end
end

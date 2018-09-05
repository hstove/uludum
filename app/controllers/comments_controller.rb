class CommentsController < ApplicationController

  def create
    flash[:alert] = "There was an error creating your comment."
    redirect_to @commentable
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize! :manage, @comment
    @comment.destroy
    respond_to do |format|
      format.html do
        redirect_to @comment.commentable,
                    notice: "Successfully deleted that comment."
      end
      format.json { head :no_content }
    end
  end
end

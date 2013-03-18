class CommentsController < ApplicationController
  
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])
    if @comment.save
      flash[:notice] = "Successfully created comment."
      redirect_to @commentable
    else
      flash[:alert] = "There was an error creating your comment."
      redirect_to @commentable
    end
  end

  private

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        model = $1.classify.constantize
        return model.find(value) if model.method_defined?(:comments)
      end
    end
    params[:comment].each do |name, value|
      if name =~ /(.+)_id$/
        model = $1.classify.constantize
        return model.find(value) if model.method_defined?(:comments)
      end
    end
    nil
  end

end

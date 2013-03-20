module CommentsHelper
  def comment_form commentable
    return nil unless logged_in?
    render partial: 'comments/form', locals: {comment: commentable.comments.new(user_id: current_user.id), commentable: commentable}
  end
end

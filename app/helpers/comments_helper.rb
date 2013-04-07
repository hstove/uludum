module CommentsHelper
  def comment_form commentable
    return nil unless logged_in?
    render partial: 'comments/form', locals: {comment: commentable.comments.new(user_id: current_user.id), commentable: commentable}
  end

  def comment_area commentable
    html = content_tag :h4, "Listing #{pluralize(commentable.comments.count, 'comment')}"
    html << render(partial: 'comments/list', locals: {comments: commentable.comments})
    if logged_in?
      html << content_tag(:h4, "Comment on this fund")
      html << comment_form(commentable)
    else
      em = content_tag :em, "You must be signed in to post a comment."
      html << content_tag(:p, em)
    end
    html
  end
end

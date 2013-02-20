class ApplicationController < ActionController::Base
  helper_method :taught?, :complete?
  include ControllerAuthentication
  protect_from_forgery

  def taught? course
    current_user && current_user.id == course.teacher_id
  end

  def complete? subsection
    logged_in? && !subsection.completions.where("user_id = ?", current_user.id).first.nil?
  end
end

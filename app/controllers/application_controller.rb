class ApplicationController < ActionController::Base
  helper_method :taught?, :complete?, :enrolled?
  include ControllerAuthentication
  protect_from_forgery

  def taught? course
    current_user && current_user.id == course.teacher_id
  end

  def complete? object
    return false unless logged_in?
    if object.class == Subsection
      return object.percent_complete(current_user) == 100
    elsif object.class == Section
      complete = true
      object.subsections.each { |sub| complete = false unless sub.complete?(current_user)}
      return complete
    elsif object.class = Course
      #TODO

    end
    Logger.info("unimplemented object in ApplicationController#complete? for class #{object.class}")
    return false
  end

  def enrolled? course
    return false if course.nil?
    logged_in? && !course.enrollments.where("user_id = ?", current_user.id).first.nil?
  end
end

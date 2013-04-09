class ApplicationController < ActionController::Base
  include ControllerAuthentication
  include MixpanelHelpers
  helper_method :taught?, :complete?, :enrolled?, :voted?, :mixpanel
  protect_from_forgery

  before_filter :set_mixpanel_person

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to login_path(return_to: request.fullpath), alert: "The content you wish to request is unavailable."
  end

  def taught? course
    current_user && current_user.id == course.teacher_id
  end

  def complete? object
    return false unless logged_in?
    if object.class == Subsection
      return object.complete? current_user
    elsif object.class == Section
      complete = true
      object.subsections.each { |sub| complete = false unless sub.complete?(current_user)}
      return complete
    elsif object.class == Course
      return object.percent_complete == 100

    end
    ap "unimplemented object in ApplicationController#complete? for class #{object.class}"
    return false
  end

  def enrolled? course
    if course.respond_to? :course
      course = course.course
    end
    return false unless course.class == Course
    return false if course.nil? || !logged_in?
    logged_in? && !course.enrollments.where("user_id = ?", current_user.id).first.nil?
  end

  def voted? wish
    wish.voted_users.include? current_user
  end

  #association should be plural, like `:comments` or `:orders`
  def find_polymorphic(association, opts={})
    params.each do |name, value|
      if name =~ /(.+)_id$/
        model = $1.classify.constantize
        return model.find(value) if model.method_defined?(association) && model != opts[:except]
      end
    end
    nil
  end

  private 

  def set_mixpanel_person
    if Rails.env.production && logged_in?
      mixpanel.set current_user.id, { :email => current_user.email, username: current_user.username }
    end
  end
end

class EnrollmentsController < ApplicationController
  before_filter :login_required
  def new
    course = Course.find(params[:course_id])
    unless course.free?
      throw "Cannot enroll in course [#{course.id}]"
    end
    @enrollment = current_user.enroll(course)
    notice = "You have been successfully enrolled"
    unless @enrollment.save
      notice = "There was an error enrolling you."
    end
    track "enrolled in course", course_id: @enrollment.course_id
    redirect_to course_path(id: params[:course_id]), notice: notice
  end

  def destroy
    enrollment = Enrollment.find(params[:id])
    authorize! :destroy, enrollment
    course = enrollment.course
    enrollment.destroy
    redirect_to course, notice: "You have been successfully unenrolled."
  end
end

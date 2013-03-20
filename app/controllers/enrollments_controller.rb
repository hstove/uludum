class EnrollmentsController < ApplicationController
  before_filter :login_required
  def new
    @enrollment = current_user.enroll(params[:course_id])
    notice = "You have been successfully enrolled"
    unless @enrollment.save
      notice = "There was an error enrolling you."
    end
    redirect_to course_path(id: params[:course_id], notice: notice)
  end

  def destroy
    enrollment = Enrollment.find(params[:id])
    authorize! :destroy, enrollment
    course = enrollment.course
    enrollment.destroy
    redirect_to course, notice: "You have been successfully unenrolled."
  end
end

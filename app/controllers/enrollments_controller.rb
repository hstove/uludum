class EnrollmentsController < ApplicationController
  def new
    @enrollment = current_user.enroll(params[:course_id])
    notice = "You have been successfully enrolled"
    unless @enrollment.save
      notice = "There was an error enrolling you."
    end
    redirect_to course_path(id: params[:course_id], notice: notice)
  end
end

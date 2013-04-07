class CompletionsController < ApplicationController
  before_filter :login_required

  def complete
    @subsection = Subsection.find(params[:subsection_id])
    @completion = Completion.find_or_create_by subsection_id: @subsection.id, user_id: current_user.id
    if (@completion.save)
      ap "completed"
      redirect_to @subsection.course.next_subsection(current_user)
    else
      ap "couldn't complete"
      ap @completion
      redirect_to @subsection, alert: "There was an error completing this subsection"
    end
  end
end

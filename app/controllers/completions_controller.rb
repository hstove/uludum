class CompletionsController < ApplicationController
  before_filter :login_required

  def complete
    @subsection = Subsection.find(params[:subsection_id])
    Completion.create subsection_id: @subsection.id, user_id: current_user.id
    redirect_to @subsection
  end
end

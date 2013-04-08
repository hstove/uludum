class DiscussionsController < ApplicationController
  before_action :set_discussion, only: [:show, :edit, :update, :destroy]
  before_action :login_required, only: [:new, :edit, :create, :update, :destroy]
  before_action :find_polymorphics

  # GET /discussions
  def index
    @discussions = @discussable.discussions.all
  end

  # GET /discussions/1
  def show

  end

  # GET /discussions/new
  def new
    @discussion = @discussable.discussions.new(user_id: current_user.id)
  end

  # GET /discussions/1/edit
  def edit
  end

  # POST /discussions
  def create
    @discussion = @discussable.discussions.new(discussion_params)
    authorize! :create, @discussion

    if @discussion.save
      redirect_to polymorphic_path([@discussable, @discussion]), notice: 'Discussion was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /discussions/1
  def update
    authorize! :update, @discussion
    if @discussion.update(discussion_params)
      redirect_to polymorphic_path([@discussable, @discussion]), notice: 'Discussion was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /discussions/1
  def destroy
    authorize! :destroy, @discussion
    @discussion.destroy
    redirect_to polymorphic_path([@discussable, Discussion]), notice: 'Discussion was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_discussion
      @discussion = Discussion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def discussion_params
      params.require(:discussion).permit(:course_id, :user_id, :title, :body)
    end

    def find_polymorphics
      if @discussion.nil?
        @discussable = find_polymorphic(:discussions)
      else
        @discussable = @discussion.discussable
      end
    end

end

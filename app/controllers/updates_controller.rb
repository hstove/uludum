class UpdatesController < ApplicationController
  before_filter :set_updateable
  load_and_authorize_resource through: :updateable

  # GET /updates
  def index
    @updates = @updateable.updates
  end

  # GET /updates/1
  def show
  end

  # GET /updates/new
  def new
    @update = @updateable.updates.new
  end

  # GET /updates/1/edit
  def edit
  end

  # POST /updates
  def create
    @update = @updateable.updates.new(update_params)

    if @update.save
      redirect_to @updateable, notice: 'Update was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /updates/1
  def update
    if @update.update(update_params)
      redirect_to @updateable, notice: 'Update was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /updates/1
  def destroy
    @update.destroy
    redirect_to @updateable, notice: 'Update was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_update
      @update = Update.find(params[:id])
    end

    def set_updateable
      @updateable = find_polymorphic(:updates)
    end

    # Only allow a trusted parameter "white list" through.
    def update_params
      params.require(:update).permit(:title, :body)
    end
end

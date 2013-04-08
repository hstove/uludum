class SubsectionsController < ApplicationController
  # GET /subsections
  # GET /subsections.json
  def index
    @subsections = Subsection.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subsections }
    end
  end

  # GET /subsections/1
  # GET /subsections/1.json
  def show
    @subsection = Subsection.find(params[:id])

    unless can? :read, @subsection
      redirect_to @subsection.course, alert: "You must enroll in this class to view it's content."
      return
    end
    authorize! :read, @subsection

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subsection }
    end
  end

  # GET /subsections/new
  # GET /subsections/new.json
  def new
    @section = Section.find(params[:section_id])
    @subsection = @section.subsections.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subsection }
    end
  end

  # GET /subsections/1/edit
  def edit
    @subsection = Subsection.find(params[:id])
  end

  # POST /subsections
  # POST /subsections.json
  def create
    @section = Section.find(params[:section_id])
    @subsection = @section.subsections.new(params[:subsection])

    respond_to do |format|
      if @subsection.save
        format.html { redirect_to @subsection, notice: 'Subsection was successfully created.' }
        format.json { render json: @subsection, status: :created, location: @subsection }
      else
        format.html { render action: "new" }
        format.json { render json: @subsection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /subsections/1
  # PUT /subsections/1.json
  def update
    @subsection = Subsection.find(params[:id])

    respond_to do |format|
      if @subsection.update_attributes(params[:subsection])
        format.html { redirect_to @subsection, notice: 'Subsection was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to edit_subsection_path(@subsection) }
        format.json { render json: @subsection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subsections/1
  # DELETE /subsections/1.json
  def destroy
    @subsection = Subsection.find(params[:id])
    @subsection.destroy

    respond_to do |format|
      format.html { redirect_to subsections_url }
      format.json { head :no_content }
    end
  end
end

class CoursesController < ApplicationController
  before_filter :login_required, only: [:new]
  # GET /courses
  # GET /courses.json
  def index
    if params[:category]
      @courses = Course.visible.where("category = ?", params[:category]).all
    elsif params[:enrolled]
      @courses = []
      Enrollment.where("user_id = ?", current_user.id).each do |e|
        @courses << e.course
      end
    elsif params[:taught] && logged_in?
      @courses = current_user.courses.unscoped.order('updated_at desc')
    elsif params[:search]
      @courses = Course.best.search(params[:search]).all
    else
      @courses = Course.best.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @courses }
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @course = Course.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.json
  def new
    @course = current_user.courses.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find(params[:id])
    authorize! :edit, @course
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(params[:course])
    authorize! :create, @course

    respond_to do |format|
      if @course.save
        format.html { redirect_to courses_path, notice: 'Course was successfully created.' }
        format.json { render json: @course, status: :created, location: @course }
      else
        format.html { render action: "new" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.json
  def update
    @course = Course.find(params[:id])
    authorize! :update, @course

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to courses_path, notice: 'Course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course = Course.find(params[:id])
    authorize! :destroy, @course
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { head :no_content }
    end
  end
end

class QuestionsController < ApplicationController
  before_filter :find_subsection, except: [:answer]
  before_filter :login_required, only: [:answer]
  # GET /questions
  # GET /questions.json
  def index
    @questions = @subsection.questions.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.json
  def new
    if params[:copy_id]
      @question = Question.find(params[:copy_id]).dup include: :answers
    else
      @question = @subsection.questions.new
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.create(params[:question])
    respond_to do |format|
      if @question.save
        format.html { redirect_to quiz_path(@question.subsection_id), notice: 'Question was successfully created.' }
        format.json { render json: @question, status: :created, location: @question }
      else
        ap "couldn't save"
        ap @question.errors
        format.html { render action: "new",  params: { subsection_id: @question.subsection_id }}
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.json
  def update

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to quiz_path(@question.subsection_id), notice: 'Question was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy

    respond_to do |format|
      format.html { redirect_to quiz_path(@question.subsection_id) }
      format.json { head :no_content }
    end
  end

  def answer
    free_answer = params[:free_answer]
    if (params[:question_id].nil? || (free_answer.nil? && params[:answer_id].nil?))
      render json: {correct: false, error: "Missing parameters"}
      return
    end
    question = Question.find(params[:question_id])
    question_answer = Answer.find_by_question_id_and_id(question.id, params[:answer_id]) unless params[:answer_id].nil?
    if question.nil? || (question_answer.nil? && !params[:answer_id].nil?)
      render json: {correct: false, error: "Invalid Resource"}
      return
    end
    answer = UserAnswer.find_or_create_by_question_id_and_user_id(question.id, current_user.id)
    answer.attempts += 1
    if !free_answer.nil?
      answer.free_answer = free_answer
      if free_answer == question.free_answer
        answer.correct = true
      end
    else
      if !question_answer.nil? && question_answer.correct
        answer.correct = true
      end
      answer.last_answer_id = answer.id
    end
    answer.save!
    respond_to do |format|
      format.html do
        path = quiz_path(question.subsection_id)
        next_q = question.subsection.incorrect_questions(current_user).sample
        path = subsection_question_path(question.subsection, next_q) unless next_q.nil?
        redirect_to path, notice: "Question was answered #{answer.correct ? '' : 'in'}correctly."
      end
      format.json { render json: { correct: answer.correct, answer: answer } }
    end
  end

  private

  def find_subsection
    @question = Question.find(params[:id]) unless params[:id].nil?
    if @question.nil?
      @subsection = Subsection.find(params[:subsection_id])
    else
      @subsection = @question.subsection
    end
  end

  def quiz_path subsection_id
    subsection_questions_path(subsection_id: subsection_id)
  end
end

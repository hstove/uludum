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
    @question = @subsection.questions.new

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
    #bootstrap question_id to answers
    params[:question][:answer_attributes].each do |key,val|
      opts = {}
    end
    @question = Question.create(params[:question])
    respond_to do |format|
      if @question.save
        format.html { redirect_to quiz_path(@question.subsection_id), notice: 'Question was successfully created.' }
        format.json { render json: @question, status: :created, location: @question }
      else
        ap "couldn't save"
        ap params[:question]
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
    question_answer = Answer.find(params[:answer_id]) unless params[:answer_id].nil?
    if question.nil? || (question_answer.nil? && !params[:answer_id].nil?)
      render json: {correct: false, error: "Invalid Resource"}
      return
    end
    answer = UserAnswer.find_or_create_by(question_id: question.id, user_id: current_user.id)
    answer.attempts += 1
    if !free_answer.nil?
      answer.free_answer = free_answer
      if question.needs_decimals? free_answer
        redirect_to [question.subsection, question], alert: "That answer was incorrect, but you were within 2 decimal places short of the answer. Try rounding less."
        return
      end
      if question.free_answer_correct?(free_answer)
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
        path = subsection_path(question.course.next_subsection(current_user))
        next_q = question.subsection.incorrect_questions(current_user).first
        path = subsection_question_path(question.subsection, next_q) unless next_q.nil?
        path = subsection_question_path(question.subsection, question) if !answer.correct
        message = "Question was answered "
        flash_name = :notice
        unless answer.correct
          flash_name = :alert
          message << 'in'
        end
        message << "correctly."
        flash[flash_name] = message
        redirect_to path 
      end
      format.json { render json: { correct: answer.correct, answer: answer } }
    end
  end

  def copy
    @question = @question.dup include: :answers, validate: false
    @question.answers.each {|a| a.question_id = @question.id; a.save}
    @question.save
    ap @question.errors
    ap @question
    ap @question.answers.all

    redirect_to edit_subsection_question_path(@question.subsection, @question)
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

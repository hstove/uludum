module QuestionsHelper
  def correct? question
    return false unless logged_in?
    answer = UserAnswer.find_by_question_id_and_user_id(question.id, current_user.id)
    !answer.nil? && answer.correct
  end
end

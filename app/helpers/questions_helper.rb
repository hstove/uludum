module QuestionsHelper
  def correct? question
    answer = UserAnswer.find_by_question_id_and_user_id(question.id, current_user.id)
    !answer.nil? && answer.correct
  end
end

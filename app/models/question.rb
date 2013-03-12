class Question < ActiveRecord::Base
  has_many :answers
  belongs_to :correct_answer, class_name: 'Answer', foreign_key: :correct_answer_id
  belongs_to :subsection
  belongs_to :section
  belongs_to :course
  accepts_nested_attributes_for :answers, allow_destroy: true

  before_create do |model|
    model.section_id = model.subsection.section_id
    model.course_id = model.subsection.course_id
  end

  validates_presence_of :subsection_id, :prompt, :course_id
  attr_accessible :prompt, :section_id, :subsection_id, :answers_attributes, :multiple_choice, :free_answer, :answer_suffix, :answer_prefix

  def correct? user
    answer = UserAnswer.find_by_question_id_and_user_id(self.id, user.id)
    !answer.nil? && answer.correct
  end

end

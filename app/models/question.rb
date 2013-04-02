class Question < ActiveRecord::Base
  # using StringUtils
  # using FloatUtils

  acts_as_list scope: :subsection

  has_many :answers
  belongs_to :correct_answer, class_name: 'Answer', foreign_key: :correct_answer_id
  belongs_to :subsection
  belongs_to :section
  belongs_to :course
  accepts_nested_attributes_for :answers, allow_destroy: true

  before_validation do |model|
    if model.new_record?
      model.section_id = model.subsection.section_id
      model.course_id = model.subsection.course_id
    end
  end

  validates_presence_of :subsection_id, :prompt, :course_id
  attr_accessible :prompt, :section_id, :subsection_id, :answers_attributes, :multiple_choice, :free_answer, :answer_suffix, :answer_prefix

  def correct? user
    answer = UserAnswer.find_by_question_id_and_user_id(self.id, user.id)
    !answer.nil? && answer.correct
  end

  def free_answer_correct? answer
    return true if answer.to_s == self.free_answer.to_s

    if answer.to_s.is_numeric? && self.free_answer.to_s.is_numeric?
      answer = answer.to_f
      free = self.free_answer.to_f
      if answer.decimals > free.decimals
        return free == answer.round(free.decimals)
      end
    end
    false
  end

  def needs_decimals? answer, debug=false
    answer = answer.to_f
    num_answer = self.free_answer.to_f

    return false if !answer.to_s.include?(".")
    ap "includes `.`" if debug
    return false unless answer.to_s.is_numeric? && self.free_answer.to_s.is_numeric?
    ap "everything is numeric" if debug
    return false if self.free_answer_correct?(answer)
    ap "its not free answer correct" if debug
    return false if num_answer.decimals < answer.decimals
    ap "num_answer decimal places (#{num_answer.decimals}) greater or more than answer decimals (#{answer.decimals})" if debug
    return false if num_answer.decimals - answer.decimals > 2
    ap "answer is within 2 decimal places" if debug
    return true if num_answer.round(answer.decimals) == answer.round(answer.decimals) && num_answer.decimals > answer.decimals
    ap "num answer doesn't round to answer" if debug
    false
  end

end

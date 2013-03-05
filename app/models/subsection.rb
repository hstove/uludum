class Subsection < ActiveRecord::Base
  belongs_to :course
  belongs_to :section
  has_many :completions
  has_many :questions

  before_create do |model|
    model.course_id = model.section.course_id
  end

  validates_presence_of :section_id, :title, :body
  
  attr_accessible :body, :course_id, :section_id, :title

  def correct_questions user
    correct = []
    self.questions.each do |q|
      correct << q if q.correct? user
    end
    correct
  end

  def incorrect_questions user
    correct = []
    self.questions.each do |q|
      correct << q unless q.correct? user
    end
    correct
  end

  def percent_complete user
    count = self.questions.count
    if count == 0
      return (self.completions.where("user_id = ?", user.id).first.nil? ? 0 : 100)
    end
    ((self.correct_questions(user).size.to_f / count) * 100).to_i
  end

  def complete? user
    self.percent_complete(user) == 100
  end

  def has_quiz?
    self.questions.count != 0
  end

end

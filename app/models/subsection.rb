class Subsection < ActiveRecord::Base
  belongs_to :course
  belongs_to :section
  has_many :completions
  has_many :questions, -> { order(:position) }

  include Progressable

  acts_as_list scope: :section

  validates_presence_of :section_id, :title, :body, :position

  before_validation :bootstrap, on: :create
  
  attr_accessible :body, :course_id, :section_id, :title, :position

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

  def calc_percent_complete user
    count = self.questions.count
    if count == 0
      return (self.completions.where("user_id = ?", user.id).first.nil? ? 0 : 100)
    end
    percent = ((self.correct_questions(user).size.to_f / count) * 100).to_i
    progress = progresses.find_or_create_by(user_id: user.id)
    old_p = progress.percent
    progress.percent = percent
    progress.save

    if old_p != percent
      section.calc_percent_complete(user)
      course.calc_percent_complete(user)
    end
    
    progress
  end

  def complete? user
    self.percent_complete(user) == 100
  end

  def has_quiz?
    self.questions.count != 0
  end

  private

  def bootstrap
    ap self if section.nil?
    self.course_id = self.section.course_id
    self.position = self.section.subsections.empty? ? 1 : self.section.subsections.collect { | sub | sub.position }.max + 1
  end

end

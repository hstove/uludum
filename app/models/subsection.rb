class Subsection < ActiveRecord::Base
  belongs_to :course
  belongs_to :section
  has_many :completions
  has_many :questions, -> { order(:position) }

  include Progressable

  after_create do
    self.course.update_all_progress
  end

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
    percent = 0
    if count == 0
      percent = (self.completion?(user) ? 100 : 0)
    else
      percent = ((self.correct_questions(user).size.to_f / count) * 100).to_i
    end
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
    count = self.questions.count
    if count == 0
      return self.completion?(user)
    end
    self.percent_complete(user) == 100
  end

  def has_quiz?
    self.questions.count != 0
  end

  def completion? user
    !self.completions.find(:first, conditions: { user_id: user.id }).nil?
  end

  def to_param
    "#{id}-#{title.slugify}"
  end

  private

  def bootstrap
    ap self if section.nil?
    self.course_id = self.section.course_id
    self.position = self.section.subsections.empty? ? 1 : self.section.subsections.collect { | sub | sub.position }.max + 1
  end

end

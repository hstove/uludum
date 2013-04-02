class Section < ActiveRecord::Base
  belongs_to :course
  has_many :subsections, -> { order(:position) }
  validates_presence_of :course_id, :title, :position

  before_validation :bootstrap, on: :create

  before_save do
    self.insert_at(position) if position_changed?
  end

  acts_as_list scope: :course
  
  attr_accessible :course_id, :position, :title, :description

  def enrolled_students
    course.enrolled_students
  end

  def percent_complete user
    completion = 0
    count = 0
    self.subsections.each do |s|
      if s.questions.count == 0
        completion += 100 if s.complete?(user)
        count += 1
      else
        completion += s.percent_complete(user)
        count += 1
      end        
    end
    (completion / count).to_i
  end

  private

  def bootstrap
    self.position = self.course.sections.empty? ? 1 : self.course.sections.collect { | s | s.position }.max + 1
  end

end

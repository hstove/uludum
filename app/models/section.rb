class Section < ActiveRecord::Base
  belongs_to :course
  has_many :subsections
  validates_presence_of :course_id, :title
  
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
end

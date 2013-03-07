class Section < ActiveRecord::Base
  belongs_to :course
  has_many :subsections
  validates_presence_of :course_id, :title
  
  attr_accessible :course_id, :position, :title, :description

  def enrolled_students
    course.enrolled_students
  end
end

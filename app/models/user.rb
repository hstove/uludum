class User < ActiveRecord::Base
  acts_as_uluser
  
  has_many :courses, foreign_key: 'teacher_id'
  has_many :enrolled_courses, through: :enrollments, source: :course
  has_many :enrollments
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :username, :email, :password, :password_confirmation, :about_me, :teacher_description, :avatar_url  

  before_validation :clear_blank_avatar_url

  def enroll course_id
    self.enrollments.create(course_id: course_id)
  end

  def enrollment_in course
    self.enrollments.where(course_id: course.id)
  end

  def points
    points = 20
    enrolled_courses.each do |course|
      points += 50
      points += course.percent_complete(self) * 10
    end
    courses.each do |course|
      points += 500
    end
    points
  end

  private

  def clear_blank_avatar_url
    if avatar_url.blank?
      self.avatar_url = nil
    end
  end
end

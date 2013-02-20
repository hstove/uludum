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
end

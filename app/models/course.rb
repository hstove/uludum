class Course < ActiveRecord::Base
  has_many :sections
  has_many :subsections
  belongs_to :teacher, class_name: 'User', foreign_key: 'teacher_id'

  validates_presence_of :title, :description, :category, :teacher_id
  attr_accessible :category, :description, :teacher_id, :title

  def self.categories
    self.select("DISTINCT(category), count(*) as count").group("category").all
  end
end

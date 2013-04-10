class Course < ActiveRecord::Base
  require 'user'
  
  has_many :sections, -> {order(:position)}, dependent: :destroy
  has_many :subsections, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :enrollments
  has_many :enrolled_students, through: :enrollments, source: :user
  has_many :orders, as: :orderable
  has_many :comments, as: :commentable
  has_many :discussions, as: :discussable

  include Progressable

  belongs_to :teacher, class_name: 'User', foreign_key: 'teacher_id'
  belongs_to :user, foreign_key: 'teacher_id'

  scope :visible, -> { where(hidden: false) }
  scope :best, -> { visible.joins(:questions).select("courses.*, count(questions.id) as question_count").order('count(questions.id) desc').group('courses.id') }
  scope :search, lambda {|q| 
    q.downcase!
    where("(lower(category) like ? or lower(description) like ? or lower(title) like ?)", "%#{q}%", "%#{q}%" , "%#{q}%")
  }

  validates_presence_of :title, :description, :category, :teacher_id
  attr_accessible :category, :description, :teacher_id, :title, :hidden, :price

  def self.categories hidden=false
    self.visible.select("DISTINCT(category) , count(*) as count").group("category").order('category').all
  end

  def next_subsection(user)
    self.sections.each do |section|
      section.subsections.each do |sub|
        return sub unless sub.complete? user
      end
    end
    self.sections.last.subsections.last
  end

  def calc_percent_complete(user)
    completion = 0
    count = 0
    self.subsections.each do |s|
      completion += s.percent_complete(user)
      count += 1       
    end
    percent = (completion / count)
    progress = self.progresses.find_or_create_by(user_id: user.id)
    progress.percent = percent
    progress.save
    progress
  end

  def update_all_progress
    course = self
    course.enrolled_students.each do |user|
      course.sections.each do |section|
        section.subsections.each do |sub|
          sub.calc_percent_complete(user)
        end
        section.calc_percent_complete(user)
      end
      course.calc_percent_complete(user)
    end
  end

  def price_in_words
    if free?
      return "free"
    else
      "$%0.2f" % price
    end
  end

  def free?
    price.nil? || price <= 0
  end

  def to_param
    "#{id}-#{title.slugify}"
  end
end

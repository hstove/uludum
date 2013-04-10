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
  belongs_to :category, counter_cache: true

  scope :visible, -> { where(hidden: false) }
  # scope :best, -> { visible.joins(:questions).select("courses.*, count(questions.id) as question_count").order('count(questions.id) desc').group('courses.id') }
  scope :bestest, -> { visible.order("questions_count desc") }
  scope :search, lambda {|q| 
    q.downcase!
    where("(lower(category_name) like ? or lower(description) like ? or lower(title) like ?)", "%#{q}%", "%#{q}%" , "%#{q}%")
  }

  default_scope -> { bestest }

  validates_presence_of :title, :description, :teacher_id, :category_id, :category_name
  validates_uniqueness_of :title

  attr_accessible :description, :teacher_id, :title, :hidden, :price, :category_id

  before_validation do |course|
    if course.category_id_changed? || course.category_name.nil?
      course.category_name = course.category.name
    end
  end

  def fix_category
    if !category.empty? && category_id.nil?
      name = category.downcase
      if name.match("economics") || name.match("finance")
        self.category_id = 1
      elsif name.match("chemistry") || name.match("physics") || name.match("science")
        self.category_id = 4
      else
        self.category_id = 5
      end
      c = Category.find(self.category_id)
      ap "Changing #{name} to #{c.name}"
      save!
    end
  end

  extend FriendlyId
  friendly_id :title, use: :slugged

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

  def from_param param
    self.class.find(:first, conditions: { slug: param} )
  end
end

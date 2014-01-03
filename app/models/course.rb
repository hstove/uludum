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
  has_one :fund
  include Progressable

  belongs_to :teacher, class_name: 'User', foreign_key: 'teacher_id'
  belongs_to :user, foreign_key: 'teacher_id'
  belongs_to :category, counter_cache: true

  scope :visible, -> { where(hidden: false) }
  # only shows courses with questions
  scope :best, -> { bestest }
  scope :bestest, -> { visible.order("coalesce(questions_count, 0) desc, updated_at desc") }
  scope :search, lambda {|q|
    q.downcase!
    where("(lower(category_name) like ? or lower(description) like ? or lower(title) like ?)", "%#{q}%", "%#{q}%" , "%#{q}%")
  }

  # default_scope -> { bestest }

  validates_presence_of :title, :description, :teacher_id, :category_id, :category_name
  validates_uniqueness_of :title

  attr_accessible :description, :teacher_id, :title, :hidden, :price, :category_id
  attr_accessible :approved

  before_validation do |course|
    if course.category_id_changed? || (course.new_record? && category_id)
      course.category_name = course.category.name
    end
  end

  # If this course if ready to be seen,
  # and has recently changed as visible or approved,
  # enroll all backers!
  after_save do
    valid = approved && visible
    changed = approved_changed? || hidden_changed?
    if changed && (fund && fund.ready?) && valid
      fund.finish_orders
    end
  end

  after_create do
    user.enroll self if user
  end


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
    percent = count == 0 ? 0 : (completion / count)
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

  def user_id
    teacher_id
  end

  def ready?
    approved && visible
  end

  def visible
    hidden == false
  end
  alias :visible? :visible

  def to_epub
    _files = subsections.order_by_position.map do |subsection|
      subsection.html_file_name
    end
    navigation = _files.each_with_index.map do |file,index|
      {label: "#{index + 1}. #{file.split("/").last.gsub(/(\d{4}\s\-\s)|(.html)/ , "")}", content: file}
    end
    _title = self.title
    username = user.username
    course = self
    epub = EeePub.make do
      title _title
      creator username
      publisher 'uludum.org'
      date Date.today
      identifier "https://www.uludum.org/courses/#{course.to_param}", :scheme => 'URL'
      uid "https://www.uludum.org/courses/#{course.to_param}"

      files _files
      nav navigation
    end
    epub_name = "tmp/courses/#{id}/#{title.slugify}.epub"
    epub.save(epub_name)
    epub_name
  end
end

class Fund < ActiveRecord::Base
  validates_presence_of :user_id, :goal_date, :goal, :price, :title
  belongs_to :course

  has_many :orders, as: :orderable
  has_many :comments, as: :commentable
  has_many :updates, as: :updateable
  has_many :backers, -> { uniq(&:id) }, through: :orders, source: :user
  belongs_to :course
  belongs_to :user

  scope :visible, -> { where("hidden = ?", false) }

  attr_accessible :title, :body, :goal, :goal_date, :price, :hidden
  attr_accessible :course_id

  after_save do
    if course_id && (course_id_changed? || new_record?)
      job = Afterparty::MailerJob.new UserMailer, :get_approval, self
      Rails.configuration.queue << job
    end
  end

  def progress
    orders.sum(:price) || 0
  end

  def percent_complete
    return 0 unless goal
    ((progress / goal) * 100).to_i
  end

  def time_ending
    seconds = self.goal_date - Time.now
    days = (seconds / 86400).to_i
    hours = (seconds / 3600).to_i
    minutes = (seconds / 60).to_i
    if days > 1
      return "#{days} days"
    elsif hours > 1
      return "#{hours} hours"
    elsif minutes > 1
      return "#{minutes} minutes"
    else
      return "#{seconds} seconds"
    end
  end

  def finished?
    progress >= goal
  end

  def ready?
    finished? && course_id && course.ready?
  end

  def finish_orders
    orders.each do |order|
      order.complete
    end
  end

  # Highcharts-formatted series of sum by day
  def payment_growth
    orders.group_by do |order|
      order.created_at.beginning_of_day
    end.map do |date, orders|
      sum = orders.collect(&:price).reduce(&:+)
      [date.to_time.to_i * 1000, sum]
    end
  end

end

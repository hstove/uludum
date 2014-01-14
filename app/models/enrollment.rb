class Enrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  validates_uniqueness_of :user_id, scope: :course_id

  attr_accessible :course_id, :user_id

  after_create do
    unless user_id == course.user_id
      job = Afterparty::MailerJob.new UserMailer, :new_enrollment, user, course
      Rails.configuration.queue << job
    end
  end

  def self.enrolled? course, user
    return false unless course && user
    !course.enrollments.where("user_id = ?", user.id).first.nil?
  end

  def self.weekly_growth
    last_week = 0
    last_week_date = nil
    week_diff = 0
    revenue = Order.group("DATE_TRUNC('week', created_at)").count.to_enum.with_index.map do |week, index|
      if last_week != 0
        growth = ((week[1] - last_week) / last_week) * 100
        if last_week_date
          growth /= ((week.first - last_week_date) / 1.week)
          week_diff = ((week.first - last_week_date) / 1.week)
        end
      else
        growth = 1
      end
      last_week_date = week.first
      last_week = week[1]
      [week.first.to_time.to_i * 1000, growth]
    end
  end
end

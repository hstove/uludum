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
    last_total = 0
    last_week_date = nil
    revenue = weekly_sums.to_enum.with_index.map do |week, index|
      new_total = last_total + week[1]
      if last_total != 0
        growth = ((new_total - last_total) / last_total.to_f) * 100.0
        if last_week_date
          growth /= ((week.first - last_week_date) / 1.week)
        end
      else
        growth = 100
      end
      last_week_date = week.first
      last_total = new_total
      [week.first.to_time.to_i * 1000, growth]
    end
  end

  def self.weekly_sums
    group("DATE_TRUNC('week', created_at)")
      .order('date_trunc_week_created_at')
      .count
  end

  def self.cumulative_growth
    sums = weekly_sums
    cumulative = []
    sums.to_enum.with_index.map do |week, index|
      time = week.first.to_time.to_i * 1000
      amount = week.last
      if index == 0
        cumulative << [time, amount]
      else
        cumulative << [time, (cumulative[index-1].last + week[1])]
      end
    end
    cumulative
  end
end

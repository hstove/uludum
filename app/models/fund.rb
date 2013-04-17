class Fund < ActiveRecord::Base
  validates_presence_of :user_id

  has_many :orders, as: :orderable
  has_many :comments, as: :commentable
  belongs_to :user

  scope :visible, -> { where("hidden = ?", false) }

  attr_accessible :title, :body, :goal, :goal_date, :price, :hidden

  def progress
    orders.sum(:price)
  end

  def percent_complete
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

end

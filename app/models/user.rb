class User < ActiveRecord::Base
  has_many :courses, foreign_key: 'teacher_id'
  has_many :enrollments
  has_many :funds
  has_many :wish_votes
  has_many :progresses
  has_many :orders

  letsrate_rater

  def enrolled_courses
    enrollments.to_a.collect{|e| e.course }.uniq {|c| c.id}
  end
  alias :enrolled_in :enrolled_courses

  ACTIVATION_POINTS ||= 150

  # include PublicActivity::Model
  # tracked

  # new columns need to be added here to be writable through mass assignment
  attr_accessible :username, :email, :password, :password_confirmation, :about_me, :teacher_description, :avatar_url, :show_email
  attr_accessible :password_reset_token, :bitcoin_address

  attr_accessor :password
  before_save :prepare_password

  after_create do |user|
    # UserMailer.welcome_email(user).deliver
    @personal = Afterparty::MailerJob.new(UserMailer, :personal, user)
    @personal.execute_at = Time.now + 3.hours
    Rails.configuration.queue << @personal
    @feedback = Afterparty::MailerJob.new(UserMailer, :feedback_or_remind, user)
    @feedback.execute_at = Time.now + 14.days
    Rails.configuration.queue << @feedback
    if Rails.env.production? && !(how_to = Course.find_by_id(117)).blank?
      Rails.configuration.queue << Afterparty::BasicJob.new(self, :enroll, how_to)
    end
    job = Afterparty::BasicJob.new(self, :subscribe_to_mailchimp)
    Rails.configuration.queue << job
  end

  validates_presence_of :username, :email
  validates_uniqueness_of :username, :email, :allow_blank => true, case_sensitive: false
  validates :username, format: { :with => /\A[-\w\._@]+\Z/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@" }
  validates :email, format: { :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\Z/i }
  validates_presence_of :password, :on => :create
  validates :password, confirmation: true
  validates_length_of :password, :minimum => 4, :allow_blank => true
  validates_length_of :bitcoin_address, is: 34, allow_blank: true

  before_validation :clear_blank_avatar_url

  def self.authenticate(login, pass)
    user = where("lower(username) = ? or lower(email) = ?", login.downcase, login.downcase).first
    if user
      user.last_login_attempt = Time.now
      # user.delay.save
      user.save
    end
    return user if user && user.password_hash == user.encrypt_password(pass)
  end

  def encrypt_password(pass)
    BCrypt::Engine.hash_secret(pass, password_salt)
  end

  def enroll course
    id = course.class == Course ? course.id : course
    self.enrollments.find_or_create_by!(course_id: id)
  end

  def enrollment_in course
    self.enrollments.where(course_id: course.id).first
  end

  def points
    _points = 20
    enrolled_in.each do |course|
      _points += 50
      _points += course.percent_complete(self) * 10
    end
    courses.each do |course|
      _points += 500
    end
    orders.each do |order|
      if order.orderable_type == "Fund"
        _points += 250
      end
    end
    _points
  end

  def created_at_in_words
    self.created_at.strftime("Joined on %B %d, %Y at %l:%I %P")
  end

  def payments
    orders = []
    courses.each do |c|
      c.orders.each { |o| orders << o }
    end
    funds.each do |f|
      f.orders.each { |o| orders << o }
    end
    orders.sort_by{|o| -o.created_at.time.to_i}
  end

  def is_admin?
    if Rails.env.development?
      return true
    else
      return self.admin == true
    end
  end

  def vote_for wish
    wish_votes.find(:first, conditions: {wish_id: wish.id})
  end

  def activated?
    points >= ACTIVATION_POINTS
  end

  # 'card' can either be a hash of credit card
  # or a token created from Stipe.js
  def create_stripe_customer card
    customer = Stripe::Customer.create(
      card: card,
      description: username,
      email: email,
    )
    self.stripe_customer_id = customer.id
    save
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    job = Afterparty::MailerJob.new UserMailer, :password_reset, self
    Rails.configuration.queue << job
  end

  # Highcharts-formatted series of sum by day
  def payment_growth
    payments.group_by do |order|
      order.created_at.beginning_of_day
    end.map do |date, orders|
      sum = orders.collect(&:price).reduce(&:+)
      [date.to_time.to_i * 1000, sum]
    end
  end

  private

  def clear_blank_avatar_url
    if avatar_url.blank?
      self.avatar_url = nil
    end
  end

  def prepare_password
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = encrypt_password(password)
    end
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def subscribe_to_mailchimp testing=false
    return true if (Rails.env.test? && !testing)
    list_id = ENV['MAILCHIMP_ULUDUM_LIST_ID']

    response = Rails.configuration.mailchimp.lists.subscribe({
      id: list_id,
      email: {email: email},
      double_optin: false,
    })
    response
  end
end

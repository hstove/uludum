class Order < ActiveRecord::Base
  require 'queue_helpers'
  include MixpanelHelpers
  validates_presence_of :user_id, :orderable_type, :orderable_id, :price
  belongs_to :orderable, polymorphic: true
  belongs_to :user

  scope :completed, -> { where("token != ? OR token != ?", "", nil) }
  scope :grouped, -> { group("user_id").select("sum(price) as sum").select("user_id") }

  APPLICATION_FEE = 0.05
  FAIL_FEE = 0.04

  before_validation do
    self.price ||= orderable.price
  end

  after_save do
    if finished? && (state_changed? || self.id_changed?)
      autoenroll
      if bitcoin_payout_address_changed? && bitcoin_amount && Rails.env.production?
        coinbase = Rails.configuration.coinbase
        coinbase.send_money bitcoin_payout_address, bitcoin_amount
      end
      job = Afterparty::MailerJob.new UserMailer, :order_complete , self
    elsif self.id_changed?
      job = Afterparty::MailerJob.new UserMailer, :order_processing, self
    end
    Rails.configuration.queue << job
  end

  after_create do
    if orderable_type == "Course"
      complete if pending?
    end
  end

  # If fund is newly finished, trigger fund completion
  after_create do
    return true unless orderable.is_a?(Fund)
    return true unless orderable.progress >= orderable.goal
    return true unless orderable.course_id && orderable.course.ready?
    return true unless orderable.finished?
    if orderable.progress - self.price < orderable.goal
      orderable.finish_orders
    else
      complete if pending?
    end
  end

  include AASM

  aasm column: 'state' do
    state :pending, initial: true
    state :processing
    state :finished
    state :errored

    event :complete, after: :charge_card do
      transitions from: :pending, to: :processing
    end

    event :finish do
      transitions to: :finished
    end

    event :fail do
      transitions from: :processing, to: :errored
    end
  end

  def status
    state
  end

  def order_fee extra_fee=false
    fee = APPLICATION_FEE
    fee += FAIL_FEE if extra_fee
    ((price * fee) * 100).to_i
  end

  private

  def autoenroll
    if orderable.class == Course && price >= orderable.price.to_i
      user.enroll orderable
    elsif orderable.class == Fund && orderable.course && orderable.course.ready? && price >= orderable.price.to_i
      user.enroll orderable.course
    end
  end

  # set extra_fee = true if unsuccessful fund
  # to charge extra 4%
  def charge_card extra_fee=false
    return true unless processing?
    begin
      oauth_key = orderable.user.stripe_key
      charge = Stripe::Charge.create({
        amount: (price * 100).to_i,
        currency: "usd",
        customer: user.stripe_customer_id,
        description: "Order for #{orderable.title.titleize}",
      }, oauth_key)
      finish
    rescue Stripe::CardError => e
      body = e.json_body
      err  = body[:error]

      logger.fatal "Status is: #{e.http_status}"
      logger.fatal "Type is: #{err[:type]}"
      logger.fatal "Code is: #{err[:code]}"
      # param is '' in this case
      logger.fatal "Param is: #{err[:param]}"
      logger.fatal "Message is: #{err[:message]}"

      self.error = e.message
      job = Afterparty::MailerJob.new UserMailer, :card_error , self
      Rails.configuration.queue << job
      fail
    end
    save!
    self
  end

end

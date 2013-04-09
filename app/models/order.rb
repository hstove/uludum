class Order < ActiveRecord::Base
  include MixpanelHelpers
  validates_presence_of :user_id, :orderable_type, :orderable_id, :uuid, :price
  belongs_to :orderable, polymorphic: true
  belongs_to :user

  scope :completed, -> { where("token != ? OR token != ?", "", nil) }
  scope :grouped, -> { completed.group("user_id").select("sum(price) as sum").select("user_id") }

  before_validation :create_uuid, on: :create

  after_save do
    if paid == true && paid_changed?
      autoenroll
      track_charge
      UserMailer.order_complete(self).deliver
    end
  end

  def self.prefill!(orderable, user, price=nil)
    order = orderable.orders.new
    order.price = price || orderable.price
    order.user = user
    order.save!

    order
  end

  def self.postfill!(options = {})
    @order = Order.find_by_uuid!(options[:callerReference])
    @order.token             = options[:tokenID]
    if @order.token.present?
      @order.status          = options[:status]
      @order.expiration      = Date.parse(options[:expiry])
      @order.save!
    end
    UserMailer.order_processing(@order).deliver
    if @order.orderable.class == Course
      @order.complete
    end

    @order
  end

  def create_uuid
    self.uuid = SecureRandom.uuid
  end

  def complete
    if self.token.present?
      begin
        AmazonFlexPay.pay(price.to_s, 'USD', self.token, self.uuid)
        self.paid = true
        save!
      rescue AmazonFlexPay::API::Error => e
        e.errors.each do |error|
          ErrorMailer.error("Unable to complete payment for order #{self.id}. Error Message: #{error.message}", self.orderable.user).deliver
        end
        raise e
      end
    end
  end

  def status
    if token.nil? || token.empty?
      return "incomplete"
    elsif paid != true
      return "processing"
    elsif paid == true
      return "completed"
    end
  end

  private

  def autoenroll
    if orderable.class == Course && price >= orderable.price
      user.enroll orderable
    end
  end

  def track_charge
    mixpanel.track_charge user.id, price if Rails.env.production?
  end

end

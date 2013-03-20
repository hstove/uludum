class Order < ActiveRecord::Base
  validates_presence_of :user_id, :orderable_type, :orderable_id, :uuid, :price
  belongs_to :orderable, polymorphic: true
  belongs_to :user

  scope :completed, -> { where("token != ? OR token != ?", "", nil) }

  before_validation :create_uuid, on: :create

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
      # @order.expiration      = Date.parse(options[:expiry])
      @order.save!

      @order
    end
  end

  def create_uuid
    self.uuid = SecureRandom.uuid
  end

  def reserve?
    orderable.class == Fund ? true : false
  end

end

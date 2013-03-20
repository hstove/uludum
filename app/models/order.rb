class Order < ActiveRecord::Base
  validates_presence_of :user_id, :orderable_type, :orderable_id, :uuid, :price
  belongs_to :orderable, polymorphic: true
  belongs_to :user

  scope :completed, -> { where("token != ? OR token != ?", "", nil) }

  before_validation :create_uuid, on: :create

  def self.prefill!(orderable, user)
    order = orderable.orders.new
    order.price = orderable.price
    order.user = user
    order.save!

    order
  end

  def create_uuid
    self.uuid = SecureRandom.uuid
  end

end
